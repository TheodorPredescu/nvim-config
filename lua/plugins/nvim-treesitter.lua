return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "typescript", "javascript", "html", "css", "python", "lua" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true }, -- this handles Enter spacing/indent automatically
    },
}
