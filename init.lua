vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "  %s%l %=%#LineNr#▎"

-- For :find
vim.opt.path:append("**")
vim.opt.wildignore:append({ "**/node_modules/**", "**/venv/**", "**/.venv/**" })
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

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
vim.opt.wrap = true
vim.opt.textwidth = 120
vim.opt.colorcolumn = "120"

-- Makes it so the neovim uses the default clipboard used by the operating system.
vim.opt.clipboard = "unnamedplus"

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.undolevels = 500

-- vim.o.winborder = "solid"

local os_name = vim.loop.os_uname().sysname
if os_name == "Linux" then
    vim.bo.fileformat = "unix"
elseif os_name == "Windows_NT" then
    vim.bo.fileformat = "dos"

    vim.opt.shell = "powershell.exe"

    -- Optional: arguments to make it behave nicely in Neovim terminal
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

vim.diagnostic.config({
    virtual_text = false, -- inline errors/warnings
    -- virtual_lines = {
    --     current_line = true, -- Only show virtual lines for the current cursor line
    -- },
    -- severity_sort = true,
    -- signs = true,
    -- underline = true,
    -- update_in_insert = true,
})

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
})

require("mason").setup()

local function setupColors()
    vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "NONE", blend = 30 })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 30 })
end
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom_menu_highlights", { clear = true }),
    pattern = "*",
    callback = setupColors,
})
setupColors()

vim.o.complete = "o"
vim.opt.completeopt = "menuone,noselect,fuzzy"
vim.o.pumheight = 10 -- max number of options displayed
vim.o.pumborder = "rounded"
vim.o.autocomplete = false

vim.lsp.enable({ "lua_ls", "pyright", "clangd", "ts_ls", "html", "css_ls", "angularls" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
        local client_id = args.data.client_id
        if not client_id then
            return
        end

        local client = vim.lsp.get_client_by_id(client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client_id, args.buf, {
                autotrigger = true,
            })
        end

        -- Angular and ts_ls try to rename bouth...
        local angular_attached = #vim.lsp.get_clients({ bufnr = args.buf, name = "angularls" }) > 0
        if angular_attached then
            for _, ts_client in
                ipairs(vim.lsp.get_clients({
                    bufnr = args.buf,
                    name = "ts_ls",
                }))
            do
                ts_client.server_capabilities.renameProvider = false
                ts_client.server_capabilities.referencesProvider = false
            end
        end
    end,
})

require("keymaps")
