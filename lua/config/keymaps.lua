vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
end, { desc = "Highlight word under cursor" })

vim.keymap.set("n", "<leader>bc", "<cmd>%bd|e#<CR>", { desc = "Delete all but the current buffer" })

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

local marginSize = 55
local left_win = nil
local right_win = nil

vim.keymap.set("n", "<leader>up", function()
    -- TOGGLE OFF (just close existing windows)
    if left_win and right_win then
        if vim.api.nvim_win_is_valid(left_win) then
            vim.api.nvim_win_close(left_win, true)
        end
        if vim.api.nvim_win_is_valid(right_win) then
            vim.api.nvim_win_close(right_win, true)
        end

        left_win, right_win = nil, nil
        return
    end

    local main_win = vim.api.nvim_get_current_win()

    -- LEFT
    vim.cmd("topleft vsplit _______")
    left_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(left_win, marginSize)
    vim.wo[left_win].winfixwidth = true
    vim.api.nvim_win_set_buf(left_win, vim.api.nvim_get_current_buf())

    -- RIGHT
    vim.api.nvim_set_current_win(main_win)
    vim.cmd("botright vsplit _______")
    right_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(right_win, marginSize)
    vim.wo[right_win].winfixwidth = true
    vim.api.nvim_win_set_buf(right_win, vim.api.nvim_get_current_buf())

    vim.wo[left_win].statusline = " "
    vim.wo[right_win].statusline = " "

    vim.api.nvim_set_current_win(main_win)
end)
