vim.env.COLORTERM = "truecolor"
vim.opt.termguicolors = true
vim.opt.background = "dark"
-----------------------------------------------------------
-- BOOTSTRAP LAZY.NVIM
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- BASIC SETTINGS
-----------------------------------------------------------
vim.g.mapleader = " "
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.termguicolors  = true
vim.opt.clipboard      = "unnamedplus"
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 250

-----------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------
require("lazy").setup({

  -- Colorscheme
{
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        background = { dark = "wave" },
      })
      vim.opt.background = "dark"
      vim.cmd.colorscheme("kanagawa")
    end,
  },

    -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = 15,
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Icons (needed for file tree + lualine)
  { "nvim-tree/nvim-web-devicons", opts = {} },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = { width = 30 },
      renderer = {
        icons = {
          show = {
            file         = true,
            folder       = true,
            folder_arrow = true,
            git          = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_closed = "",
              arrow_open   = "",
              default      = "",
              open         = "",
              empty        = "",
              empty_open   = "",
              symlink      = "",
            },
            git = {
              unstaged  = "",
              staged    = "",
              unmerged  = "",
              renamed   = "",
              untracked = "",
              deleted   = "",
              ignored   = "",
            },
          },
        },
      },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Mason
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "gopls", "pyright", "ts_ls",
        "clangd", "lua_ls", "bashls",
      },
    },
  },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = {
          autocomplete = {
            require("cmp.types").cmp.TriggerEvent.TextChanged,
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        fast_wrap = {},
      })
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Go extras
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    config = function()
      require("go").setup()
    end,
  },

})

-----------------------------------------------------------
-- NATIVE TREESITTER (Neovim 0.11 built-in)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-----------------------------------------------------------
-- LSP SETUP
-----------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  gopls   = { settings = { gopls = { gofumpt = true, staticcheck = true } } },
  pyright = {},
  ts_ls   = {},
  clangd  = {},
  bashls  = {},
  lua_ls  = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace   = { checkThirdParty = false },
      },
    },
  },
}

for server, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-----------------------------------------------------------
-- GO: format on save
-----------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern  = "*.go",
  callback = function() vim.lsp.buf.format() end,
})

-----------------------------------------------------------
-- C/C++: format on save (via clangd)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.cxx" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-----------------------------------------------------------
-- KEYMAPS
-----------------------------------------------------------
-- Escape
vim.keymap.set("i", "jk", "<Esc>")

-- Window navigation (replaces <C-w> prefix)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- File tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

-- LSP
vim.keymap.set("n", "gd",         vim.lsp.buf.definition)
vim.keymap.set("n", "K",          vim.lsp.buf.hover)
vim.keymap.set("n", "gr",         vim.lsp.buf.references)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>d",  vim.diagnostic.open_float)

-- Go
vim.keymap.set("n", "<leader>r", ":!go run %<CR>")
vim.keymap.set("n", "<leader>b", ":!go build<CR>")
vim.keymap.set("n", "<leader>t", ":!go test ./...<CR>")

