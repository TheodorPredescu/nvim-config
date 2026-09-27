return {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
    workspace_required = false,
    init_options = { provideFormatter = true },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}
