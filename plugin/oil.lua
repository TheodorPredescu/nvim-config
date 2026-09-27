vim.pack.add({
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/stevearc/oil.nvim",
})

require("mini.icons").setup()
require("oil").setup({
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        ["<C-c>"] = false,
    },
})
vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Exit terminal mode" })
