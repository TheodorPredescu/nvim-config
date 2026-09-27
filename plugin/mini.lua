vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
})

require("mini.icons").setup()
require("mini.pairs").setup()

local pick = require("mini.pick")
pick.setup()
vim.keymap.set("n", "<leader>f", pick.builtin.files)

vim.keymap.set("n", "<leader>bl", function()
    pick.builtin.buffers()
end, { desc = "Buffers" })

