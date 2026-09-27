vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",

	ensure_installed = { "typescript", "javascript", "html", "css", "lua", "python", "c", "cpp" },
	auto_install = true,
})
