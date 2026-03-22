vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showmode = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoread = true

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
local swapDir = vim.fn.stdpath("state") .. "/swap"
vim.opt.swapfile = true

vim.opt.directory = swapDir .. "//"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.undolevels = 500

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local os_name = vim.loop.os_uname().sysname
if os_name == "Linux" then
    vim.bo.fileformat = "unix"
elseif os_name == "Windows_NT" then
    vim.bo.fileformat = "dos"

    vim.opt.shell = "pwsh.exe"

    -- Optional: arguments to make it behave nicely in Neovim terminal
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

-- Makes it so the neovim uses the default clipboard used by the operating system.
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            styles = {
                floats = "transparent",
            },
        },
    },
    -- Mason (manages LSP binaries)
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
            local mason_tool_installer = require("mason-tool-installer")
            mason_tool_installer.setup({
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "eslint_d",
                    "ruff",
                    "clang-format",
                },
            })
        end,
    },

    -- Mason LSP integration
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            local mason_lsp = require("mason-lspconfig")

            mason_lsp.setup({
                ensure_installed = { "pyright", "clangd", "lua_ls" },
            })

            -- The html lsp used in vscode does not check for htmlangular files, but only for html.
            if vim.lsp.config.html then
                vim.lsp.config.html = {
                    filetypes = { "html", "htmlangular" },
                }
            end
            vim.lsp.config("ts_ls", {
                on_attach = function(client, _)
                    client.server_capabilities.referencesProvider = false
                end,
            })

            vim.lsp.config("angularls", {
                on_attach = function(client, _)
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            })
        end,
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
                        max_height = 10, -- max number of entries shown
                        max_width = 50, -- max width in characters
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
        end,
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
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre", -- load when a buffer is opened
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { hl = "GitGutterAdd", text = "│", numhl = "GitGutterAddNr", linehl = "GitGutterAddLn" },
                    change = {
                        hl = "GitGutterChange",
                        text = "│",
                        numhl = "GitGutterChangeNr",
                        linehl = "GitGutterChangeLn",
                    },
                    delete = {
                        hl = "GitGutterDelete",
                        text = "_",
                        numhl = "GitGutterDeleteNr",
                        linehl = "GitGutterDeleteLn",
                    },
                    topdelete = {
                        hl = "GitGutterDelete",
                        text = "‾",
                        numhl = "GitGutterDeleteNr",
                        linehl = "GitGutterDeleteLn",
                    },
                    changedelete = {
                        hl = "GitGutterChange",
                        text = "~",
                        numhl = "GitGutterChangeNr",
                        linehl = "GitGutterChangeLn",
                    },
                },
                current_line_blame = false, -- shows git blame for current line
                watch_gitdir = {
                    follow_files = true,
                },
                sign_priority = 6,
                update_debounce = 100,
            })
        end,
    },

    -- Fuzzy finder and live grep with telescome
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- optional but recommended
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = { "truncate" },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@diagnostic disable-next-line: undefined-doc-name
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["<C-c>"] = false,
            },
        },
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {

            ensure_installed = { "typescript", "javascript", "html", "css", "python", "lua" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true }, -- this handles Enter spacing/indent automatically
        },
    },
    {
        "kshenoy/vim-signature",
        config = function()
            vim.g.SignatureMarkText = "⚑" -- mark symbol
            vim.g.SignatureColumnWidth = 2
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
                ts_config = {
                    lua = { "string" }, -- don't autopair in strings
                    javascript = { "template_string" },
                    typescript = { "template_string" },
                },
                enable_check_bracket_line = true,
                fast_wrap = {},
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    typescriptangular = { "prettier" },
                    svelte = { "prettier" },
                    cssangular = { "prettier" },
                    html = { "prettier" },
                    htmlangular = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    graphql = { "prettier" },
                    lua = { "stylua" },
                    python = { "ruff_format" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                svelte = { "eslint_d" },
                python = { "ruff" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            highlight = true,
            separator = " > ",
            depth_limit = 5,
        },
    },
})

-- ========================================================================== --
------------------------------- End of require ---------------------------------
-- ========================================================================== --

vim.cmd([[colorscheme tokyonight-night]])

-- Some color costumization for vim marks
-- Normal marks '
vim.api.nvim_set_hl(0, "SignatureMarkText", { fg = "#00ff00", bg = "NONE", bold = false })
-- Uppercase marks (A-Z)
vim.api.nvim_set_hl(0, "SignatureMarkTextUpper", { fg = "#00ff00", bg = "NONE", bold = false })
-- Marks in the current line
vim.api.nvim_set_hl(0, "SignatureMarkCurrentLine", { fg = "#ff00ff", bg = "NONE", bold = false })

vim.diagnostic.config({
    virtual_text = true, -- inline errors/warnings
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = true,
})

-- Set buffer-local LSP keymaps dynamically when any LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local navic = require("nvim-navic")

        if client ~= nil and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end

        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({
                border = "rounded",
            })
        end, { buffer = bufnr, silent = true, desc = "Hover" })

        vim.keymap.set("n", "<C-k>", function()
            vim.lsp.buf.signature_help({
                border = "rounded",
            })
        end, { buffer = bufnr, silent = true, desc = "Signature help" })

        vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action({
                window = {
                    border = "rounded",
                    row = 1,
                    col = vim.o.columns / 2,
                },
            })
        end, { buffer = bufnr, silent = true, desc = "Code action" })

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
            buffer = bufnr,
            desc = "Rename symbol",
        })

        vim.keymap.set("n", "<leader>w", function()
            local conform = require("conform")
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { buffer = bufnr, desc = "Format buffer" })
    end,
})

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- Mimic persistence bihaviour
local session_dir = vim.fn.stdpath("state") .. "/sessions/"

-- make sure the directory exists
vim.fn.mkdir(session_dir, "p")

-- sanitize cwd to a filename-safe string
local function session_path()
    local cwd = vim.fn.getcwd()
    local name = cwd:gsub("[/\\:]", "%%")
    return session_dir .. name .. ".vim"
end

-- save session
vim.keymap.set("n", "<leader>qc", function()
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path()))
    print("Session saved")
end, { desc = "Save session (cwd)" })

-- load session
vim.keymap.set("n", "<leader>qs", function()
    local path = session_path()
    if vim.fn.filereadable(path) == 1 then
        vim.cmd("source " .. vim.fn.fnameescape(path))
        print("Session loaded")
    else
        print("No session found for this directory")
    end
end, { desc = "Load session (cwd)" })

vim.keymap.set("n", "<leader>ql", function()
    require("telescope.builtin").find_files({
        prompt_title = "Sessions",
        cwd = session_dir,
        previewer = false,
        attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function source_session()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("source " .. vim.fn.fnameescape(selection.path))
            end

            map("i", "<CR>", source_session)
            map("n", "<CR>", source_session)
            return true
        end,
    })
end, { desc = "Browse and source sessions" })

vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
end, { desc = "Highlight word under cursor" })

-- Telescope commands
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>b", function()
    builtin.buffers({
        sort_mru = true,
    })
end, { desc = "Telescope buffers" })
-- vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'LSP Definitions' })
-- vim.keymap.set("n", "<leader>d", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP references" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "LSP implementation" })

-- vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- It will help when I have errors in a big file and dont whant to scroll to them.
vim.keymap.set("n", "<leader>e", builtin.diagnostics, { desc = "Diagnostics" })

-- Search for searching by name important components from this file (like functions, classes, class parameters). It will
-- not search for function variables and stuff like that.
vim.keymap.set("n", "<leader>d", builtin.lsp_document_symbols, { desc = "Document symbols" })

-- harpoon2
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end)
vim.keymap.set("n", "<leader>h", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>1", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
    harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>5", function()
    harpoon:list():select(5)
end)
vim.keymap.set("n", "<leader>6", function()
    harpoon:list():select(6)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>p", function()
    harpoon:list():prev()
end)
vim.keymap.set("n", "<leader>n", function()
    harpoon:list():next()
end)

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

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-\\>", function()
    vim.cmd("stopinsert")
    toggle_terminal()
end, { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-\\>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "gbc", "<Esc>O */<Esc>O<Esc>I <Esc>O<Esc>I/*<Esc>jA ")
-- vim.keymap.set("n", "gbc", function()
--     local row = vim.api.nvim_win_get_cursor(0)[1]
--
--     vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, {
--         "/**",
--         " *",
--         " */",
--     })
--
--     -- After a short period of time, format those 3 lines using the lsp formatter.
--     vim.lsp.buf.format({
--         range = {
--             ["start"] = { row, 0 },
--             ["end"] = { row + 2, 0 },
--         },
--         async = false,
--     })
--
--     local middle_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
--     -- Find position after "* "
--     local col = middle_line:find("%*%s") or 1
--
--     -- Move cursor safely
--     vim.api.nvim_win_set_cursor(0, { row + 1, col })
--     vim.api.nvim_feedkeys("a ", "n", false)
-- end)

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
