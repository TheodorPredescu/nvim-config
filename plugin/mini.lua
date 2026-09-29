vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
})

require("mini.icons").setup()
require("mini.pairs").setup()

local pick = require("mini.pick")
pick.setup()

local wide_picker = {
    window = {
        config = {
            width = math.min(220, vim.o.columns - 4),
        },
    },
}

vim.keymap.set("n", "<leader>f", function()
    pick.builtin.files({}, wide_picker)
end)

vim.keymap.set("n", "<leader>bl", function()
    pick.builtin.buffers({}, wide_picker)
end, { desc = "Buffers" })
