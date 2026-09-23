# Vimium (Chrome)

Source of truth for [Vimium](https://github.com/philc/vimium) settings shared
across machines. Chrome cannot symlink extension options, so apply these by
pasting into the extension UI.

## Apply

1. Open `chrome://extensions` → Vimium → Details → Extension options
   (or press `?` in a normal page, then open Options).
2. **Excluded URLs**: replace the field with the contents of `excluded-urls`.
3. **Custom key mappings**: replace the field with the contents of `key-mappings`.
4. Click **Show Advanced Options**.
5. **CSS for link hints**: replace the field with the contents of `link-hints.css`.
6. Save.

Do not exclude GitHub, X (Twitter), Google Cloud Console, or Cloudflare
Dashboard; Vimium stays useful there.

## Design notes

- Hammerspoon uses `Ctrl+A` as a leader; it does not fight Vimium’s bare keys.
- Conductor Monokey base is QWERTY, so default Vimium mappings stay fine.
- Chrome owns new tab (`Cmd+T`), close tab (`Cmd+W`), restore tab (`Shift+Cmd+T`), and reload (`Cmd+R`), so their single-key Vimium equivalents are unmapped.
- Tab switching remains in Vimium: `J`/`K`, `gt`/`gT`, and `H`/`L` (`H` for previous tab, `L` for next tab; default history navigation on `H`/`L` is disabled).
- Prefer excluding keyboard-heavy web apps over remapping Vimium keys.
