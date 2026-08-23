# My NeoVim Config

WezTerm + NeoVim のシンプルな構成。

## プラグイン

| プラグイン | 用途 |
|-----------|------|
| tokyonight.nvim | カラースキーム |
| snacks.nvim | ファイラー / ファインダー / ターミナル / LazyGit / ダッシュボード / インデント / 通知 |
| nvim-treesitter | シンタックスハイライト |
| gitsigns.nvim | バッファ内の Git 差分表示 |
| bufferline.nvim | バッファタブ |
| lualine.nvim | ステータスライン |
| which-key.nvim | キーバインドヘルプ |
| arto.vim | Markdown プレビュー (Arto) |

## キーマップ

Leader キーは `Space`。

### 基本操作

| キー | 操作 |
|------|------|
| `<Space>w` | 保存 |
| `<Space>x` | バッファを閉じる |
| `<Space>X` | バッファを閉じる（変更を破棄） |
| `<Space>wx` | 保存してバッファを閉じる |
| `<Space>q` | 終了 |
| `Shift+l` / `Shift+h` | 次/前のバッファ |

### ファイル操作

| キー | 操作 |
|------|------|
| `<Space>e` | ファイルエクスプローラの表示/非表示 |
| `<Space>o` | 現在のファイルをエクスプローラで表示 |
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | テキスト検索 (live grep) |
| `<Space>fb` | バッファ一覧 |
| `<Space>fs` | カーソル下の単語を検索 |
| `<Space>fr` | 最近開いたファイル |
| `<Space>fk` | キーマップ検索 |

### Git

| キー | 操作 |
|------|------|
| `<Space>gg` | LazyGit を起動 |
| `<Space>gB` | 現在のファイルを GitHub で開く |
| `]c` / `[c` | 次/前の変更箇所にジャンプ |
| `<Space>hp` | 変更内容をプレビュー |
| `<Space>hs` | ハンクをステージ |
| `<Space>hr` | ハンクをリセット |
| `<Space>hb` | blame 表示 |
| `<Space>hd` | diff 表示 |

### ターミナル

| キー | 操作 |
|------|------|
| `<Space>t` | フローティングターミナルのトグル |
| `Esc Esc` | ターミナルモードを抜ける |

### マークダウン

| キー | 操作 |
|------|------|
| `<Space>mp` | Arto でプレビュー |

### その他

| キー | 操作 |
|------|------|
| `<Space>un` | 通知履歴 |

## エディタ設定

- インデント: スペース 2
- 行番号: 絶対 + 相対
- クリップボード: システムと共有
- 背景透過: WezTerm の透過設定に対応
