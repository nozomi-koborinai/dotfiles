import { parse as parseToml } from "@std/toml";
import { parseAll as parseYaml } from "@std/yaml";

const ROOT = new URL("../", import.meta.url);
const MARKDOWN_LINK = /!?\[[^\]]*]\(([^)]+)\)/g;
const STRUCTURED_LOADERS: Record<string, (text: string) => unknown> = {
  ".json": JSON.parse,
  ".toml": parseToml,
  ".yaml": parseYaml,
  ".yml": parseYaml,
};

async function* repositoryFiles(directory = ROOT): AsyncGenerator<URL> {
  for await (const entry of Deno.readDir(directory)) {
    if (entry.name === ".git") continue;

    const suffix = entry.isDirectory ? "/" : "";
    const url = new URL(
      `${encodeURIComponent(entry.name)}${suffix}`,
      directory,
    );
    if (entry.isDirectory) {
      yield* repositoryFiles(url);
    } else if (entry.isFile) {
      yield url;
    }
  }
}

function relativePath(url: URL): string {
  return decodeURIComponent(url.pathname.slice(ROOT.pathname.length));
}

function extension(url: URL): string {
  return url.pathname.match(/\.[^.\/]+$/)?.[0].toLowerCase() ?? "";
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}

async function validateStructuredFiles(errors: string[]): Promise<number> {
  let checked = 0;

  for await (const file of repositoryFiles()) {
    const loader = STRUCTURED_LOADERS[extension(file)];
    if (!loader) continue;

    checked += 1;
    try {
      loader(await Deno.readTextFile(file));
    } catch (error) {
      errors.push(`${relativePath(file)}: ${errorMessage(error)}`);
    }
  }

  return checked;
}

function localLinkUrl(markdown: URL, rawTarget: string): URL | undefined {
  let target = rawTarget.trim();
  if (target.startsWith("<") && target.endsWith(">")) {
    target = target.slice(1, -1);
  } else {
    target = target.split(/\s+/, 1)[0];
  }

  if (!target || target.startsWith("#")) return;

  const url = new URL(target, markdown);
  return url.protocol === "file:" ? url : undefined;
}

async function exists(url: URL): Promise<boolean> {
  try {
    await Deno.stat(url);
    return true;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false;
    throw error;
  }
}

async function validateMarkdownLinks(errors: string[]): Promise<number> {
  let checked = 0;

  for await (const markdown of repositoryFiles()) {
    if (extension(markdown) !== ".md") continue;

    const text = await Deno.readTextFile(markdown);
    for (const match of text.matchAll(MARKDOWN_LINK)) {
      const target = localLinkUrl(markdown, match[1]);
      if (!target) continue;

      checked += 1;
      if (!(await exists(target))) {
        errors.push(
          `${relativePath(markdown)}: missing local link ${
            JSON.stringify(match[1])
          }`,
        );
      }
    }
  }

  return checked;
}

async function validateAgentInstructions(errors: string[]): Promise<void> {
  const agents = new URL("AGENTS.md", ROOT);
  const claude = new URL("CLAUDE.md", ROOT);

  if (!(await exists(agents))) {
    errors.push("AGENTS.md: canonical agent instructions are missing");
  } else if ((await Deno.stat(agents)).size > 32 * 1024) {
    errors.push("AGENTS.md: exceeds Codex's default 32 KiB instruction limit");
  }

  if (
    !(await exists(claude)) ||
    (await Deno.readTextFile(claude)).trim() !== "@AGENTS.md"
  ) {
    errors.push("CLAUDE.md: expected the single adapter line '@AGENTS.md'");
  }
}

async function main(): Promise<void> {
  const errors: string[] = [];
  const structured = await validateStructuredFiles(errors);
  const links = await validateMarkdownLinks(errors);
  await validateAgentInstructions(errors);

  if (errors.length > 0) {
    console.error("Validation failed:");
    for (const error of errors) console.error(`  - ${error}`);
    Deno.exit(1);
  }

  console.log(
    `Validated ${structured} structured files and ${links} local links.`,
  );
}

await main();
