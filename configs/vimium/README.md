# Vimium (Chrome)

Source of truth for [Vimium](https://github.com/philc/vimium) settings shared
across machines. Chrome cannot symlink extension options, so apply these by
pasting into the extension UI.

## Apply

1. Open Vimium options: paste/open `chrome-extension://dbepggeogbaibhgnhhndojpepiihcmeb/pages/options.html` in Chrome (or `chrome://extensions` → Vimium → Details → Extension options).
2. Excluded URLs ← contents of `excluded-urls`
3. Custom key mappings ← contents of `key-mappings`
4. Show Advanced Options → CSS for link hints ← `link-hints.css`
5. Save

Note: the `chrome-extension://` URL only works directly in Chrome with Vimium installed (GitHub web won't open it).

Do not exclude GitHub, X (Twitter), Google Cloud Console, or Cloudflare
Dashboard; Vimium stays useful there.

## Design notes

- Hammerspoon uses `Ctrl+A` as a leader; it does not fight Vimium’s bare keys.
- Conductor Monokey base is QWERTY, so default Vimium mappings stay fine.
- Chrome owns new tab (`Cmd+T`), close tab (`Cmd+W`), restore tab (`Shift+Cmd+T`), and reload (`Cmd+R`), so their single-key Vimium equivalents are unmapped.
- Tab switching uses `H`/`L` (`H` for previous tab, `L` for next tab; default history navigation on `H`/`L` is disabled) and `gt`/`gT`.
- `J`/`K` are unmapped from default tab switching and mapped to `scrollDown count=2` / `scrollUp count=2` for 2x scroll speed.
- Prefer excluding keyboard-heavy web apps over remapping Vimium keys.
