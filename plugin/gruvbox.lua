vim.pack.add({
    "https://github.com/ellisonleao/gruvbox.nvim"
})

require("gruvbox").setup({
    terminal_colors = true,
    contrast = "hard",

    overrides = {
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        SignColumn = { bg = "NONE" },

        MarginBackground = { bg = "#141617" },
    },
})
vim.cmd.colorscheme("gruvbox")
vim.o.background = "dark"
