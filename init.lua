vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showmode = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true

-- tab to spaces
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.scrolloff = 4
vim.opt.wrap = true
vim.opt.textwidth = 120
vim.opt.colorcolumn = "120"

vim.opt.backup = false
local swapDir = vim.fn.stdpath("state") .. '/swap'
vim.opt.swapfile = true

vim.opt.directory = swapDir .. "//"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.undolevels=500

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Makes it so the neovim uses the default clipboard used by the operating system.
vim.opt.clipboard = 'unnamedplus'
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Automatic putting pairs for each a 'opening' element
vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', "'", "''<Left>")
vim.keymap.set('i', '"', '""<Left>')
vim.keymap.set('i', '`', '``<Left>')
vim.keymap.set('i', '<CR>', function()
    local col = vim.fn.col('.') - 1
    local line = vim.fn.getline('.')

    -- Check if cursor is between { and }
    if col > 0 and line:sub(col, col) == '{' and line:sub(col + 1, col + 1) == '}' then
        -- Insert two new lines and position cursor on the middle line
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<CR><CR><Esc>k==i", true, false, true), 'n', true
        )
        return ""
    else
        return "\n"
    end
end, { expr = true, noremap = true })


--------------------------------- LAZY ---------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
      {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
              styles = {
                floats = "transparent", -- or "dark"
              },
            })
          -- load the colorscheme here
          vim.cmd([[colorscheme tokyonight-night]])
        end,
      },
  -- Mason (manages LSP binaries)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- Mason LSP integration
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
        local mason_lsp = require("mason-lspconfig")

        mason_lsp.setup({
            ensure_installed = { "pyright", "tsserver", "clangd", "lua_ls" }
        })
    end
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
          window = {
            completion = {
              max_height = 10,        -- max number of entries shown
              max_width = 50,         -- max width in characters
              border = "rounded",     -- optional but nice
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            },
            documentation = {
              max_height = 15,
              max_width = 60,
              border = "rounded",
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = { { name = "nvim_lsp" } },
      })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  }

})

vim.diagnostic.config({
    virtual_text = true,   -- inline errors/warnings
    signs = true,          -- gutter icons
    underline = true,
    update_in_insert = false,
})

-- Set buffer-local LSP keymaps dynamically when any LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        vim.keymap.set("n", "gd", vim.lsp.buf.definition,
          { buffer = bufnr, silent = true, desc = "Go to definition" })

        vim.keymap.set("n", "K", function ()
            vim.lsp.buf.hover({
            border = "rounded" })
        end,
          { buffer = bufnr, silent = true, desc = "Hover" })

        vim.keymap.set("n", "<C-k>", function()
          vim.lsp.buf.signature_help({
            border = "rounded",
          })
        end, { buffer = bufnr, silent = true, desc = "Signature help" })

        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, silent = true, desc = "Reference" })

        vim.keymap.set("n", "<leader>ca", function ()
            vim.lsp.buf.code_action({
              window = {
                border = "rounded",
                row = 1,
                col = vim.o.columns / 2,
              }
            })
        end,
          { buffer = bufnr, silent = true, desc = "Code action" })
    end
})
