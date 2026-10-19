vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local treesitter = require("nvim-treesitter")

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",

})

treesitter.install({
    "typescript",
    "tsx",
    "javascript",
    "html",
    "css",
    "lua",
    "python",
    "c",
    "cpp",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
    callback = function(args)
        -- Start highlighting when a parser is available.
        pcall(vim.treesitter.start, args.buf)
    end,
})
