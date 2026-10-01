vim.pack.add({
    "https://github.com/folke/snacks.nvim",
})

local snacks = require("snacks")

snacks.setup({
    picker = {
        enabled = true,
        ui_select = false,
        live = true,

        win = {
            input = {
                bo = {
                    autocomplete = false,
                },
            },
        },

        layout = {
            select = {
                layout = "ivy",
            },
            layout = {
                box = "horizontal",
                backdrop = false,
                width = 0.8,
                height = 0.9,
                border = "none",
                {
                    box = "vertical",
                    {
                        win = "input",
                        height = 1,
                        border = true,
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                    },
                    { win = "list", title = " Results ", title_pos = "center", border = true },
                },
                {
                    win = "preview",
                    title = "{preview:Preview}",
                    width = 0.65,
                    border = true,
                    title_pos = "center",
                },
            },
        },
        -- Fuzzy matching settings
        matcher = {
            fuzzy = true,
            smartcase = true,
            filename_bonus = true,
        },
    },
})

vim.keymap.set("n", "<leader>e", function()
    snacks.picker.diagnostics()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>/", function()
    snacks.picker.grep()
end)
