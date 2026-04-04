return {
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
}
