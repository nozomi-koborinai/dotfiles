---
name: vde-layout
description: "Manage and modify vde-layout workspace layouts. Use when changing pane structures, modifying startup applications, or adding layout presets."
---

# vde-layout Workspace Configuration

Manages WezTerm pane layouts via vde-layout. Launchable from the WezTerm Command Palette (`Cmd+P`).

## Related Files

- `~/dotfiles/configs/vde/layout/config.yml` — Preset definitions (YAML)
- `~/dotfiles/configs/wezterm/wezterm.lua` — Command Palette entries (`augment-command-palette`)

## Workflow

1. Read `config.yml` to understand existing preset layouts.
2. Edit or add presets based on requirements.
3. If a new preset is added, register the entry in `wezterm.lua` under `augment-command-palette`.
4. Verify generated commands with `vde-layout <preset> --dryRun`.

## Structure of config.yml

```yaml
presets:
  preset-key:
    name: "Display Name"
    description: "Description"
    backend: wezterm
    layout:
      type: horizontal | vertical  # Split orientation
      ratio: [1, 1]                # Ratio weights for panes
      panes:
        - name: pane-name
          command: "command-to-run"
          cwd: "~/path"            # Working directory (optional)
          focus: true              # Focused pane (only one)
        - type: vertical           # Nestable layout
          ratio: [85, 15]
          panes: [...]
```

## Notes

- `ratio` represents relative weights (`[1, 1]` = 50:50, `[85, 15]` = 85:15).
- Strings like `"90c"` specify fixed cell counts.
- `focus: true` can only be set on one pane per layout.
- Ensure `backend: wezterm` is set for all presets.
