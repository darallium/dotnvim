# Darallium's Neovim設定

**Language / 言語**: [English](README.md) | [日本語](README.jp.md)

LazyVimをベースにした、使いやすくて高性能なNeovim設定です！色んなプログラミング言語に対応していて、どのOSでも動きます。

## ✨ このツールの良いところ

- **🚀 それなりにめっちゃ速い**: LazyVimベースで必要な時だけプラグインを読み込むので、起動が早いです WSL上でも0.5ms以内は出ると思います
- **🔧 最新版対応**: Neovim 0.11+の新しい機能と、ある程度古いバージョンの両方で使えます
- **🌍 色んな言語OK**: TypeScript、Lua、Python、Rust、C++、LaTeX、JSONなど、よく使う言語はバッチリです
- **⚡ 軽快動作**: キャッシュや遅延読み込みで、サクサク動きます(LazyVim)
- **🔍 わかりやすいエラー表示**: エラーや警告が見やすく表示されます
- **🛠️ 開発に便利**: デバッグ、テスト、フォーマットが簡単にできます

## 🎯 どんな言語が使えるの？

### 対応言語・ツール

- **TypeScript/JavaScript**: コード補完やヒント表示、Prettierでの自動整形
- **Lua**: lazy.nvimライブラリ対応で、高度な設定ができます
- **Python**: Rye仮想環境を自動で見つけてくれるPyright統合
- **Rust**: rust-analyzerの詳細設定で、Rust開発がとても楽になります
- **C/C++**: clangdでインデックス作成とclang-tidyチェック
- **LaTeX**: 論文や文書作成に便利なLTeXサーバー
- **JSON**: スキーマ検証と整形機能

## 🔧 必要なもの

- **Neovim**: 0.11+がオススメ（0.10+でも一応大丈夫）
- **Git**: プラグイン管理に使います
- **Node.js**: TypeScript/JavaScript開発に必要
- **Python**: Python開発するなら（Ryeにも対応）
- **Rust**: Rust開発するなら（cargo/rustc）
- **C/C++**: C/C++開発するならclangd

### 動作環境

- ✅ **Linux**: tmuxクリップボード連携で完璧に動きます
- ✅ **macOS**: pbcopy/pbpasteで快適に使えます
- ✅ **Windows (WSL)**: win32yankでクリップボード連携ができます

## 🚀 インストール方法

1. **既存の設定をバックアップ**（大事！）:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **このリポジトリをダウンロード**:
   ```bash
   git clone https://github.com/darallium/neovim-config ~/.config/nvim
   ```

3. **Neovimを起動**:
   ```bash
   nvim
   ```

4. **プラグインが自動インストール**: 初回起動時にLazy.nvimが勝手にやってくれます！

## 📁 ファイル構成

```
lua/
├── core/                    # Neovimの基本設定
│   ├── init.lua            # メインの読み込み
│   ├── options.lua         # エディタの設定
│   ├── keymap.lua          # キーボードショートカット
│   ├── lsp.lua             # LSP設定（新しいAPI用）
│   └── global.lua          # 全体設定とOS判定
├── plugins/                 # プラグイン設定
│   ├── lsp.lua             # LSP設定（両方対応）
│   ├── Telescope.lua       # ファイル検索
│   ├── nvim-treesitter.lua # 構文ハイライト
│   ├── cmp.lua             # 補完機能
│   ├── rust.lua            # Rust専用ツール
│   ├── copilot.lua         # GitHub Copilot
│   ├── colorscheme.lua     # 色設定
│   ├── dashboard.lua       # スタート画面
│   └── ui.lua              # 見た目の改善
└── util.lua                # 便利な関数
```

## 🔑 よく使うキー操作

### LSPナビゲーション
- `gd` - 定義に移動
- `gD` - 宣言に移動
- `gi` - 実装に移動
- `gr` - 参照を表示
- `K` - 詳細情報を表示

### Telescope
- `;;` - ファイル検索を開く

### Rust使用時
- `<leader>ca` - コードアクション
- `<leader>dr` - デバッグ実行

## 🎨 使用プラグイン

### 基本プラグイン
- **[LazyVim](https://github.com/LazyVim/LazyVim)**: モダンなNeovim設定の土台
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: 高速なプラグインマネージャー
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: LSP設定
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: 補完エンジン
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: 構文ハイライト

### 開発ツール
- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)**: ファジーファインダー
- **[rustaceanvim](https://github.com/mrcjkb/rustaceanvim)**: Rust開発ツール
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**: デバッグツール
- **[GitHub Copilot](https://github.com/github/copilot.vim)**: AIコード補完

### 言語サポート
- **[none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)**: フォーマットとリント
- **[crates.nvim](https://github.com/saecki/crates.nvim)**: Rustクレート管理
- **[nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)**: コンテキスト表示

## 🔧 詳しい設定について

### LSPハイブリッド設定

Neovim 0.11+の新しいAPIと、古いnvim-lspconfigの両方に対応してます：

```lua
-- バージョンを自動判定
if vim.fn.has('nvim-0.11') == 1 then
  require("core.lsp").setup(capabilities)  -- 新しいAPI
else
  -- 従来の設定
end
```

### 言語ごとの便利機能

#### TypeScript
- `package.json`があるプロジェクトでのみLSPが起動
- パラメータ、型、戻り値のヒント表示
- 保存時にPrettierで自動整形

#### Rust
- 450行以上の詳細なrust-analyzer設定
- カスタム補完スニペット（Ok、Some、Err、Arc::new等）
- デバッグとテストツールの統合
- クレートバージョン管理

#### Python
- Rye仮想環境の自動検出
- ワークスペース全体の解析
- Pythonインタープリターの自動検出

## 🤝 貢献方法

1. リポジトリをフォーク
2. 機能ブランチを作成（`git checkout -b feature/新機能`）
3. 変更をコミット（`git commit -m '新機能を追加'`）
4. ブランチにプッシュ（`git push origin feature/新機能`）
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはGPLv3ライセンスです - 詳細は[LICENSE](./LICENSE)ファイルをご覧ください。

## 🙏 感謝

- 素晴らしい基盤を提供してくれた[LazyVim](https://github.com/LazyVim/LazyVim)
- 最高のエディターを作ってくれた[Neovim](https://github.com/neovim/neovim)チーム
- Neovimエコシステムを支えてくれた全てのプラグイン作者の皆さん

## 🔧 困った時は

### よくある問題

1. **LSPが動かない**: 言語サーバーがインストールされているか確認してください
2. **起動が遅い**: プラグインの遅延読み込み設定を確認してください
3. **クリップボードが使えない**: `xclip`、`pbcopy`、`win32yank`がインストールされているか確認してください
4. **TypeScriptでエラーが出る**: `package.json`があるNode.jsプロジェクトで使っているか確認してください
5. **Avante実行時にエラーが出る**:  ghコマンドあたりに環境依存不具合がありますので、gh_check_testの先頭にreturn 1を追記してください

### 確認コマンド

```bash
# Neovimバージョン確認
nvim --version

# LSPの状態確認
:LspInfo

# プラグインの状態確認
:Lazy

# 全体の健康チェック
:checkhealth
```

---

