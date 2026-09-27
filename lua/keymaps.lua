vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Hover documentation" })
-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- - "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
-- - "gri" is mapped to |vim.lsp.buf.implementation()|
-- - "grn" is mapped to |vim.lsp.buf.rename()|
-- - "grr" is mapped to |vim.lsp.buf.references()|
-- - "grt" is mapped to |vim.lsp.buf.type_definition()|
-- - "grx" is mapped to |vim.lsp.codelens.run()|
-- - "gO" is mapped to |vim.lsp.buf.document_symbol()|
-- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|

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

local function feedKey(key)
    local command = vim.api.nvim_replace_termcodes(key, true, false, true)
    vim.api.nvim_feedkeys(command, "n", false)
end

vim.keymap.set("t", "<M-/>", function()
    vim.cmd("stopinsert")
    toggle_terminal()
end, { desc = "Exit terminal mode" })

vim.keymap.set("n", "<M-/>", toggle_terminal, { desc = "Toggle terminal" })

vim.keymap.set("t", "<M-[>", function()
    feedKey([[<C-\><C-n>]])
end, { desc = "Exit terminal mode" })

local session_dir = vim.fn.stdpath("state") .. "/sessions/"

-- make sure the directory exists
vim.fn.mkdir(session_dir, "p")

-- sanitize cwd to a filename-safe string
local function session_path()
    local cwd = vim.fn.getcwd()
    local name = cwd:gsub("[/\\:]", "%%")
    return session_dir .. name .. ".vim"
end

-- save session
vim.keymap.set("n", "<leader>qc", function()
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path()))
    print("Session saved")
end, { desc = "Save session (cwd)" })

-- load session
vim.keymap.set("n", "<leader>qs", function()
    local path = session_path()
    if vim.fn.filereadable(path) == 1 then
        vim.cmd("source " .. vim.fn.fnameescape(path))
        print("Session loaded")
    else
        print("No session found for this directory")
    end
end, { desc = "Load session (cwd)" })
