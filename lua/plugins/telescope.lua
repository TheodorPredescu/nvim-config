return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- optional but recommended
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            -- Telescope commands
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<leader>b", function()
                builtin.buffers({
                    sort_mru = true,
                })
            end, { desc = "Telescope buffers" })
            -- vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'LSP Definitions' })
            -- vim.keymap.set("n", "<leader>d", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
            vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP references" })
            vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "LSP implementation" })

            -- vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope help tags' })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

            -- It will help when I have errors in a big file and dont whant to scroll to them.
            vim.keymap.set("n", "<leader>e", builtin.diagnostics, { desc = "Diagnostics" })

            -- Search for searching by name important components from this file (like functions, classes, class parameters). It will
            -- not search for function variables and stuff like that.
            vim.keymap.set("n", "<leader>d", builtin.lsp_document_symbols, { desc = "Document symbols" })

            -- Mimic persistence bihaviour
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

            vim.keymap.set("n", "<leader>ql", function()
                require("telescope.builtin").find_files({
                    prompt_title = "Sessions",
                    cwd = session_dir,
                    previewer = false,
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")

                        local function source_session()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            vim.cmd("source " .. vim.fn.fnameescape(selection.path))
                        end

                        map("i", "<CR>", source_session)
                        map("n", "<CR>", source_session)
                        return true
                    end,
                })
            end, { desc = "Browse and source sessions" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = { "truncate" },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
