vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showmode = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
-- vim.bo.fileformat = "dos" -- or unix

-- tab to spaces
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.autoindent = true
vim.opt.smartindent = false

vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.textwidth = 120
vim.opt.colorcolumn = "120"

vim.opt.backup = false
local swapDir = vim.fn.stdpath("state") .. '/swap'
vim.opt.swapfile = true

vim.opt.directory = swapDir .. "//"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.undolevels = 500

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
-- vim.keymap.set('i', '<CR>', function()
--     local col = vim.fn.col('.') - 1
--     local line = vim.fn.getline('.')
--
--     -- Check if cursor is between { and }
--     if col <= 0 then
--         return "\n"
--     end
--     local first = line:sub(col, col);
--     local second = line:sub(col + 1, col + 1);
--     if (first == '(' and second == ')') or
--         (first == '[' and second == ']') or
--         (first == '{' and second == '}')
--     then
--         -- Insert two new lines and position cursor on the middle line
--         vim.api.nvim_feedkeys(
--             vim.api.nvim_replace_termcodes("<CR><Esc>O", true, false, true), 'n', true
--         )
--         return ""
--     else
--         return "\n"
--     end
-- end, { expr = true, noremap = true })


--------------------------------- LAZY ---------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                styles = {
                    floats = "transparent",
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
                ensure_installed = { "pyright", "clangd", "lua_ls" }
            })

            -- The html lsp used in vscode does not check for htmlangular files, but only for html.
            if vim.lsp.config.html then
                vim.lsp.config.html = {
                    filetypes = { 'html', 'htmlangular' }
                }
            end
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
                        max_height = 10,    -- max number of entries shown
                        max_width = 50,     -- max width in characters
                        border = "rounded", -- optional but nice
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
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre", -- load when a buffer is opened
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { hl = "GitGutterAdd", text = "│", numhl = "GitGutterAddNr", linehl = "GitGutterAddLn" },
                    change       = { hl = "GitGutterChange", text = "│", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
                    delete       = { hl = "GitGutterDelete", text = "_", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
                    topdelete    = { hl = "GitGutterDelete", text = "‾", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
                    changedelete = { hl = "GitGutterChange", text = "~", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
                },
                current_line_blame = false, -- shows git blame for current line
                watch_gitdir = {
                    follow_files = true
                },
                sign_priority = 6,
                update_debounce = 100,
            })
        end
    },

    -- Fuzzy finder and live grep with telescome
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@diagnostic disable-next-line: undefined-doc-name
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["<C-c>"] = false,
            }
        },
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        lazy = false,

    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",                             -- this will only start session saving when an actual file was opened
        opts = {
            dir = vim.fn.stdpath("data") .. "/sessions/", -- where sessions are stored
            options = { "buffers", "curdir", "tabpages", "winsize" },
            autosave = true,                              -- automatically save sessions
            autoload = true,                              -- automatically load last session on start
            -- only keep one session, always overwrite
            pre_save = function()
                local last_session = vim.fn.stdpath("data") .. "/sessions/last_session.vim"
                vim.fn.delete(last_session) -- delete previous one
            end,
        }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        opts = {

            ensure_installed = { "typescript", "javascript", "html", "css", "python", "lua" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true }, -- this handles Enter spacing/indent automatically
        }
    }
})

vim.diagnostic.config({
    virtual_text = true, -- inline errors/warnings
    signs = true,        -- gutter icons
    underline = true,
    update_in_insert = true,
})

-- Set buffer-local LSP keymaps dynamically when any LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({
                    border = "rounded" })
            end,
            { buffer = bufnr, silent = true, desc = "Hover" })

        vim.keymap.set("n", "<C-k>", function()
            vim.lsp.buf.signature_help({
                border = "rounded",
            })
        end, { buffer = bufnr, silent = true, desc = "Signature help" })

        -- vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, silent = true, desc = "Reference" })

        vim.keymap.set("n", "<leader>ca", function()
                vim.lsp.buf.code_action({
                    window = {
                        border = "rounded",
                        row = 1,
                        col = vim.o.columns / 2,
                    }
                })
            end,
            { buffer = bufnr, silent = true, desc = "Code action" })

        -- Format on save
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     buffer = bufnr,
        --     callback = function()
        --         vim.lsp.buf.format({ async = false })
        --     end,
        -- })

        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
                require("persistence").save({ last = true, silent = true })
            end,
        })

        vim.keymap.set('n', '<leader>w', function()
                vim.lsp.buf.format({ async = true })
            end,
            { buffer = bufnr, desc = "Format buffer" })
    end
})

vim.keymap.set('n', '<leader>L', function()
        require("persistence").load({ last = true, silent = true })
    end,
    { desc = "Format buffer" })

-- Telescope commands
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'LSP Definitions' })
vim.keymap.set('n', '<leader>d', builtin.lsp_workspace_symbols, { desc = 'LSP Workspace Symbols' })
vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = "LSP references" })

-- vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })


-- harpoon2
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>p", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end)


-- Make toggle terminal on <leader> t with history preserved.
local term_buf = nil
local term_win = nil

local function toggle_terminal()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
        return
    end

    vim.cmd("botright split | resize 15")

    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_win_set_buf(0, term_buf)
    else
        vim.cmd("terminal")
        term_buf = vim.api.nvim_get_current_buf()
    end

    term_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>t", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>ct", function()
  local ft = vim.bo.filetype
  if ft ~= "typescript" and ft ~= "typescriptreact" then
    vim.notify("Not a TypeScript file", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_put({ "/**", " * ", " */" }, "l", true, true)
  vim.cmd("normal! kA")
end, { desc = "Comment TypeScript" })
-- Bugs the lazygit interface. It acts like a terminal (its probably one in the backgroud).
-- vim.keymap.set("t", "<leader>t", function()
--   vim.api.nvim_feedkeys(
--     vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true),
--     "n",
--     true
--   )
--   toggle_terminal()
-- end, { desc = "Toggle terminal" })
