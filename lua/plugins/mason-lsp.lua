return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
            local mason_tool_installer = require("mason-tool-installer")
            mason_tool_installer.setup({
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "eslint_d",
                    "ruff",
                    "clang-format",
                },
            })
        end,
    },

    -- Mason LSP integration
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            local mason_lsp = require("mason-lspconfig")

            mason_lsp.setup({
                ensure_installed = { "pyright", "clangd", "lua_ls" },
            })

            -- The html lsp used in vscode does not check for htmlangular files, but only for html.
            if vim.lsp.config.html then
                vim.lsp.config.html = {
                    filetypes = { "html", "htmlangular" },
                }
            end

            -- vim.lsp.config("ts_ls", {
            --     on_attach = function(client, _)
            --         client.server_capabilities.referencesProvider = false
            --     end,
            -- })

            -- vim.lsp.config("angularls", {
            --     on_attach = function(client, _)
            --         client.server_capabilities.documentRangeFormattingProvider = false
            --     end,
            -- })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf

                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover({
                            border = "rounded",
                        })
                    end, { buffer = bufnr, silent = true, desc = "Hover" })

                    vim.keymap.set("n", "<C-k>", function()
                        vim.lsp.buf.signature_help({
                            border = "rounded",
                        })
                    end, { buffer = bufnr, silent = true, desc = "Signature help" })

                    vim.keymap.set("n", "<leader>ca", function()
                        vim.lsp.buf.code_action({
                            window = {
                                border = "rounded",
                                row = 1,
                                col = vim.o.columns / 2,
                            },
                        })
                    end, { buffer = bufnr, silent = true, desc = "Code action" })

                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
                        buffer = bufnr,
                        desc = "Rename symbol",
                    })
                end,
            })
        end,
    },
}
