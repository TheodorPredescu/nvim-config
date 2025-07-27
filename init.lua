vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lazy config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Treesitter
require("lazy").setup({
    --=============================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate"
    },

-- ------------------------------------------------------------------------------
    -- Mason
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end
    },

-- ------------------------------------------------------------------------------
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp'
        },

        config = function()
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "clangd" }, -- servers you want
                automatic_installation = true,
            })
            require("mason-lspconfig").setup({
                function(server_name)
                    lspconfig[server_name].setup {}
                end
            })

            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            }

            vim.diagnostic.config({
                virtual_text = {
                    spacing = 2,
                    prefix = "●",
                },
                signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = true,
            })

            local cmp = require('cmp')
            local cmp_select = {behavior = cmp.SelectBehavior.Select}

            local cmp_mappings = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            })

            -- Remove Tab mappings if you don’t want them
            cmp_mappings['<Tab>'] = nil
            cmp_mappings['<S-Tab>'] = nil

            cmp.setup({
                mapping = cmp_mappings,
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'luasnip' },
                }),
            })
        end
    },
-- ------------------------------------------------------------------------------
    {
        -- Main LSP configuration
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            vim.api.nvim_create_autocmd("LspAttach", {

                callback = function(ev)
                    local opts = {buffer = ev.buf, silent = true, noremap = true}
                    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
                    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>")
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })
        end
    },

    --=============================================================================
    -- Colorscheme
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("moonfly")
        end,
    },

    --=============================================================================
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = { width = 0.9, height = 0.9 },
                },
            })
        end
    },

    --=============================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,  -- enable Treesitter integration
            })
        end
    },

    --=============================================================================
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            require("neo-tree").setup()
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
        end
    },

    --=============================================================================
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
})

require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        -- disable = { "c", "rust" },
    },
}

require("config.config")
require("config.keymaps")
