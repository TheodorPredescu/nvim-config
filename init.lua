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
vim.opt.wrap = false
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
    virtual_text = true, -- inline errors/warnings
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = true,
})

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
})

require("mason").setup()

vim.o.complete = ".,w,b,o"
vim.opt.completeopt = "menuone,noselect,fuzzy"
vim.o.pumheight = 10 -- max number of options displayed
vim.o.pumborder = "rounded"
vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "NONE", blend = 30 })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 30 })

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
        vim.keymap.set("n", "grn", function()
            vim.lsp.buf.rename(nil, {
                filter = function(rename_client)
                    return not angular_attached or rename_client.name ~= "ts_ls"
                end,
            })
        end, { buffer = args.buf, desc = "LSP rename" })
    end,
})

require("keymaps")
