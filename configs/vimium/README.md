# Vimium (Chrome)

Source of truth for [Vimium](https://github.com/philc/vimium) settings shared
across machines. Chrome cannot symlink extension options, so apply these by
pasting into the extension UI.

## Apply

1. Open `chrome://extensions` → Vimium → Details → Extension options
   (or press `?` in a normal page, then open Options).
2. **Excluded URLs**: replace the field with the contents of `excluded-urls`.
3. **Custom key mappings**: leave empty (defaults). If you later add remaps,
   put them in `key-mappings` and paste that field too.
4. Save.

Do not exclude GitHub, X (Twitter), Google Cloud Console, or Cloudflare
Dashboard; Vimium stays useful there.

## Design notes

- Hammerspoon uses `Ctrl+A` as a leader; it does not fight Vimium’s bare keys.
- Conductor Monokey base is QWERTY, so default Vimium mappings stay fine.
- Prefer excluding keyboard-heavy web apps over remapping Vimium keys.
