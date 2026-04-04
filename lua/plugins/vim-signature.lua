return {
    "kshenoy/vim-signature",
    config = function()
        vim.g.SignatureMarkText = "⚑" -- mark symbol
        vim.g.SignatureColumnWidth = 2
    end,
}
