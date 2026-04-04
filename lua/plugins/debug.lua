return {
    {
        "https://github.com/mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "mason-org/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")

            require("dapui").setup({
                icons = {
                    expanded = "▾",
                    collapsed = "▸",
                    current_frame = "→",
                    -- Breakpoint icons
                    breakpoint = "●",
                    breakpoint_condition = "◆",
                    stopped = "▶",
                    log_point = "◆",
                },
                controls = {
                    icons = {
                        pause = "⏸",
                        play = "▶",
                        step_into = "⏎",
                        step_over = "↷",
                        step_out = "↳",
                        step_back = "↶",
                        run_last = "⟲",
                        terminate = "⏹",
                    },
                },
            })
            require("dap-go").setup()

            local js_debugger = vim.fn.exepath("js-debug-adapter")
            if js_debugger ~= "" then
                dap.adapters["pwa-chrome"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "js-debug-adapter",
                        args = { "${port}" },
                    },
                }

                dap.configurations.typescript = {
                    {
                        type = "pwa-chrome",
                        request = "launch",
                        name = "Launch Angular",
                        url = "http://localhost:4200",
                        webRoot = "${workspaceFolder}",
                    },
                }
            end

            vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>dr", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F12>", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
