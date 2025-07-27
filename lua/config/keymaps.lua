vim.keymap.set("x", "<leader>y", '"+y')
vim.keymap.set("x", "<leader>p", '"+P')
vim.keymap.set("n", "<leader>p", '"+p')

vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "Live grep" })


vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-/>", function ()
  local buf = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
  if buftype == "terminal" then
    vim.cmd("bd!") -- wipe the terminal buffer
    return
  end
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0,10)
end)
