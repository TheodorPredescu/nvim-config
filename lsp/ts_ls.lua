return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "tsconfig.json",
        "jsconfig.json",
        "package.json",
        ".git",
    },
    init_options = {
        supportsHoverVerbosity = true,
        preferences = {
            maximumHoverLength = 10000,
        },
        tsserver = {
            path = vim.fs.joinpath(
                vim.fn.stdpath("data"),
                "mason",
                "packages",
                "typescript-language-server",
                "node_modules",
                "typescript",
                "lib"
            ),
        },
    },
}
