return {
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
}
