return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre", -- load when a buffer is opened
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add = {
                    hl = "GitGutterAdd",
                    text = "┃",
                    numhl = "GitGutterAddNr",
                    linehl = "GitGutterAddLn",
                },
                change = {
                    hl = "GitGutterChange",
                    text = "┃",
                    numhl = "GitGutterChangeNr",
                    linehl = "GitGutterChangeLn",
                },
                delete = {
                    hl = "GitGutterDelete",
                    text = "━",
                    numhl = "GitGutterDeleteNr",
                    linehl = "GitGutterDeleteLn",
                },
                topdelete = {
                    hl = "GitGutterDelete",
                    text = "━",
                    numhl = "GitGutterDeleteNr",
                    linehl = "GitGutterDeleteLn",
                },
                changedelete = {
                    hl = "GitGutterChange",
                    text = "┅",
                    numhl = "GitGutterChangeNr",
                    linehl = "GitGutterChangeLn",
                },
            },

            signs_staged = {
                add = {
                    hl = "GitGutterStagedAdd",
                    text = "│",
                },
                change = {
                    hl = "GitGutterStagedChange",
                    text = "│",
                },
                delete = {
                    hl = "GitGutterStagedDelete",
                    text = "_",
                },
                topdelete = {
                    hl = "GitGutterStagedDelete",
                    text = "‾",
                },
                changedelete = {
                    hl = "GitGutterStagedChange",
                    text = "~",
                },
            },
            signs_staged_enable = true,
            current_line_blame = false, -- shows git blame for current line
            watch_gitdir = {
                follow_files = true,
            },
            sign_priority = 6,
            update_debounce = 100,
        })

        vim.api.nvim_set_hl(0, "GitGutterStagedAdd", {
            fg = "#5f650d",
        })

        vim.api.nvim_set_hl(0, "GitGutterStagedChange", {
            fg = "#8a6418",
        })

        vim.api.nvim_set_hl(0, "GitGutterStagedDelete", {
            fg = "#7a1c18",
        })
    end,
}
