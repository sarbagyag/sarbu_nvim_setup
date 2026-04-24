# Neovim Config

A Neovim setup built around lazy.nvim with LSP, autocomplete, fuzzy finding, and Go tooling.

## Requirements

- **Neovim >= 0.11**
- **Git**
- **A C compiler** (for Treesitter parsers) — `gcc` or `clang`
- **Node.js** (for `ts_ls` and `bashls`)
- **Go** (for `gopls` and go.nvim tooling)
- **Python** (for `pyright`)
- **ripgrep** — for Telescope live grep (`brew install ripgrep` / `apt install ripgrep`)
- A [Nerd Font](https://www.nerdfonts.com/) set in your terminal (for icons)

## Installation

1. **Back up your existing config** if you have one:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repo** into your Neovim config directory:
   ```bash
   git clone https://github.com/sarbagya/nvim ~/.config/nvim
   ```

3. **Open Neovim** — lazy.nvim bootstraps itself on first launch and installs all plugins:
   ```bash
   nvim
   ```
   Wait for all plugins to finish installing, then restart Neovim.

4. **Install LSP servers** via Mason. Inside Neovim run:
   ```
   :MasonInstall gopls pyright ts_ls clangd lua-language-server bash-language-server
   ```
   Or open the Mason UI with `:Mason` and install from there.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | Colorscheme (Wave theme) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client config |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocomplete |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git decorations in gutter |
| [go.nvim](https://github.com/ray-x/go.nvim) | Go extras (test, run, format) |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating/split terminal |

## LSP Languages

Automatically configured: **Go**, **Python**, **TypeScript/JavaScript**, **C/C++**, **Lua**, **Bash**

## Keymaps

**Leader key: `Space`**

### General
| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<leader>e` | Toggle file tree |

### Telescope
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List open buffers |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | Find references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>d` | Show diagnostics |

### Go
| Key | Action |
|-----|--------|
| `<leader>r` | `go run` current file |
| `<leader>b` | `go build` |
| `<leader>t` | `go test ./...` |

### Terminal
| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle terminal (horizontal split) |

## Notes

- Go files are **formatted on save** via `gopls`.
- Treesitter highlighting uses Neovim 0.11's built-in parser — no separate `nvim-treesitter` plugin needed.
- Plugin versions are locked in `lazy-lock.json`. Run `:Lazy update` to update plugins and `:Lazy restore` to roll back.
