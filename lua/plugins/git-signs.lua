return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre", -- load when a buffer is opened
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { hl = "GitGutterAdd", text = "│", numhl = "GitGutterAddNr", linehl = "GitGutterAddLn" },
                change = {
                    hl = "GitGutterChange",
                    text = "│",
                    numhl = "GitGutterChangeNr",
                    linehl = "GitGutterChangeLn",
                },
                delete = {
                    hl = "GitGutterDelete",
                    text = "_",
                    numhl = "GitGutterDeleteNr",
                    linehl = "GitGutterDeleteLn",
                },
                topdelete = {
                    hl = "GitGutterDelete",
                    text = "‾",
                    numhl = "GitGutterDeleteNr",
                    linehl = "GitGutterDeleteLn",
                },
                changedelete = {
                    hl = "GitGutterChange",
                    text = "~",
                    numhl = "GitGutterChangeNr",
                    linehl = "GitGutterChangeLn",
                },
            },
            current_line_blame = false, -- shows git blame for current line
            watch_gitdir = {
                follow_files = true,
            },
            sign_priority = 6,
            update_debounce = 100,
        })
    end,
}
