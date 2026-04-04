return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                typescriptangular = { "prettier" },
                svelte = { "prettier" },
                cssangular = { "prettier" },
                html = { "prettier" },
                htmlangular = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "ruff_format" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        })

        vim.keymap.set("n", "<leader>w", function()
            local conform = require("conform")
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { buffer = bufnr, desc = "Format buffer" })
    end,
}
