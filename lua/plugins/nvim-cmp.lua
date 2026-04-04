return {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
            window = {
                completion = {
                    max_height = 10, -- max number of entries shown
                    max_width = 50, -- max width in characters
                    border = "rounded", -- optional but nice
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                },
                documentation = {
                    max_height = 15,
                    max_width = 60,
                    border = "rounded",
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                },
            },
            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            },
            sources = { { name = "nvim_lsp" } },
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end,
}
