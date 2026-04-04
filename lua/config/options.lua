vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

-- Makes it so the neovim uses the default clipboard used by the operating system.
vim.opt.clipboard = "unnamedplus"

vim.opt.backup = false
local swapDir = vim.fn.stdpath("state") .. "/swap"
vim.opt.swapfile = true

vim.opt.directory = swapDir .. "//"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.undolevels = 500

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
