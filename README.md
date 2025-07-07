# Darallium's Neovim Configuration

**Language / 言語**: [English](README.md) | [日本語](README.jp.md)

A modern, performance-optimized Neovim configuration built on LazyVim with support for multiple programming languages and cross-platform compatibility.

## ✨ Features

- **🚀 Modern Architecture**: Built on LazyVim with lazy loading for optimal performance
- **🔧 Neovim 0.11+ Support**: Hybrid LSP setup supporting both new `vim.lsp.config()` API and legacy `nvim-lspconfig`
- **🌍 Multi-Language Support**: TypeScript, Lua, Python, Rust, C++, LaTeX, and JSON with comprehensive LSP configurations
- **📦 Smart Plugin Management**: Organized plugin structure with `core/` and `plugins/` separation
- **🎯 Type Safety**: Extensive LuaCATS annotations for better development experience
- **⚡ Performance Optimized**: Lazy loading, caching, and efficient startup times
- **🔍 Advanced Diagnostics**: Rich diagnostic display with virtual text and inlay hints
- **🛠️ Development Tools**: Integrated debugging, testing, and formatting capabilities

## 🎯 Language Support

### Supported Languages & Tools

- **TypeScript/JavaScript**: Full LSP support with inlay hints, auto-formatting with Prettier
- **Lua**: Advanced configuration with lazy.nvim library support and LuaCATS annotations
- **Python**: Pyright integration with Rye virtual environment detection
- **Rust**: Comprehensive rust-analyzer setup with extensive configuration and debugging
- **C/C++**: clangd with background indexing and clang-tidy integration
- **LaTeX**: LTeX language server for academic writing
- **JSON**: Schema validation and formatting

## 🔧 System Requirements

- **Neovim**: 0.11+ (recommended) or 0.10+ (legacy support)
- **Git**: For plugin management and version control
- **Node.js**: For TypeScript/JavaScript development
- **Python**: For Python development (Rye supported)
- **Rust**: For Rust development (cargo/rustc)
- **C/C++**: clangd for C/C++ development

### Platform Support

- ✅ **Linux**: Full support with tmux clipboard integration
- ✅ **macOS**: Native clipboard support with pbcopy/pbpaste
- ✅ **Windows (WSL)**: win32yank integration for seamless clipboard

## 🚀 Installation

1. **Backup your existing Neovim configuration**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/darallium/neovim-config ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

4. **Install plugins**: Lazy.nvim will automatically install all plugins on first startup.

## 📁 Configuration Structure

```
lua/
├── core/                    # Core Neovim settings
│   ├── init.lua            # Core module loader
│   ├── options.lua         # Vim options and settings
│   ├── keymap.lua          # Key mappings
│   ├── lsp.lua             # New LSP API (Neovim 0.11+)
│   └── global.lua          # Global variables and platform detection
├── plugins/                 # Plugin configurations
│   ├── lsp.lua             # LSP configuration (hybrid setup)
│   ├── Telescope.lua       # Fuzzy finder
│   ├── nvim-treesitter.lua # Syntax highlighting
│   ├── cmp.lua             # Completion engine
│   ├── rust.lua            # Rust-specific tools
│   ├── copilot.lua         # GitHub Copilot integration
│   ├── colorscheme.lua     # Color scheme settings
│   ├── dashboard.lua       # Start screen
│   └── ui.lua              # UI enhancements
└── util.lua                # Utility functions
```

## 🔑 Key Mappings

### LSP Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Hover documentation

### Telescope
- `;;` - Open Telescope picker

### Rust-specific (when in Rust files)
- `<leader>ca` - Code actions
- `<leader>dr` - Debug runnables

## 🎨 Plugins

### Core Plugins
- **[LazyVim](https://github.com/LazyVim/LazyVim)**: Modern Neovim configuration framework
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: Plugin manager with lazy loading
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: LSP configuration
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: Completion engine
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Syntax highlighting

### Development Tools
- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)**: Fuzzy finder
- **[rustaceanvim](https://github.com/mrcjkb/rustaceanvim)**: Rust development tools
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**: Debug adapter protocol
- **[GitHub Copilot](https://github.com/github/copilot.vim)**: AI pair programming

### Language Support
- **[none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)**: Formatting and linting
- **[crates.nvim](https://github.com/saecki/crates.nvim)**: Rust crate management
- **[nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)**: Context-aware syntax highlighting

## 🔧 Advanced Configuration

### LSP Hybrid Setup

This configuration supports both Neovim 0.11+ native LSP API and legacy nvim-lspconfig:

```lua
-- Automatic version detection
if vim.fn.has('nvim-0.11') == 1 then
  require("core.lsp").setup(capabilities)  -- New API
else
  -- Legacy lspconfig setup
end
```

### Language-specific Features

#### TypeScript
- Project-aware LSP activation (only in directories with `package.json`)
- Comprehensive inlay hints for parameters, types, and return values
- Auto-formatting with Prettier on save

#### Rust
- Extensive rust-analyzer configuration with 450+ lines of settings
- Custom completion snippets (Ok, Some, Err, Arc::new, etc.)
- Integrated debugging and testing tools
- Crate management with semantic versioning

#### Python
- Rye virtual environment auto-detection
- Pyright with workspace-wide analysis
- Auto-detection of Python interpreters

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the GPLv3 License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) for the excellent foundation
- [Neovim](https://github.com/neovim/neovim) team for the amazing editor
- All plugin authors who make the Neovim ecosystem incredible

## 🔧 Troubleshooting

### Common Issues

1. **LSP not starting**: Check if the language server is installed and available in PATH
2. **Slow startup**: Ensure plugins are properly configured for lazy loading
3. **Clipboard issues**: Verify clipboard tools are installed (`xclip`, `pbcopy`, or `win32yank`)
4. **TypeScript errors**: Ensure you're in a Node.js project with `package.json`

### Debug Commands

```bash
# Check Neovim version
nvim --version

# Check LSP status
:LspInfo

# Check plugin status
:Lazy

# Check health
:checkhealth
```

---

