return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        styles = {
            floats = "transparent",
        },
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd([[colorscheme tokyonight-night]])
    end,
}
