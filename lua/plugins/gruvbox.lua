return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,

    config = function()
        vim.o.background = "dark"

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
    end,
}
