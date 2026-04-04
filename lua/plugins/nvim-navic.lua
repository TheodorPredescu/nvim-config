return {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
        highlight = true,
        separator = " > ",
        depth_limit = 5,
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local navic = require("nvim-navic")

                if client ~= nil and client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, args.buf)
                end

                vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
            end,
        })
    end,
}
