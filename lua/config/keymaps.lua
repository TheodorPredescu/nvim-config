vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
end, { desc = "Highlight word under cursor" })

-- Make toggle terminal on <leader> t with history preserved.
local term_buf = nil
local term_win = nil

local function toggle_terminal()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
        return
    end

    vim.cmd("botright split | resize 15")

    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_win_set_buf(0, term_buf)
    else
        vim.cmd("terminal")
        term_buf = vim.api.nvim_get_current_buf()
    end

    term_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
end

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-\\>", function()
    vim.cmd("stopinsert")
    toggle_terminal()
end, { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-\\>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "gbc", "<Esc>O */<Esc>O<Esc>I <Esc>O<Esc>I/*<Esc>jA ")
