return {
    filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
    root_markers = { "angular.json", "nx.json" },
    cmd = function(dispatchers, config)
        local project_modules = vim.fs.joinpath(config.root_dir, "node_modules")
        local mason_modules =
            vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "angular-language-server", "node_modules")
        local server_modules = vim.fs.joinpath(mason_modules, "@angular", "language-server", "node_modules")
        return vim.lsp.rpc.start({
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            project_modules .. "," .. mason_modules,
            "--ngProbeLocations",
            project_modules .. "," .. server_modules .. "," .. mason_modules,
        }, dispatchers)
    end,
}
