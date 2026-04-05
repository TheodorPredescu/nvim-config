return {
    {
        "https://github.com/mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "mason-org/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")

            require("dapui").setup()
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                clear_on_continue = false,
                virt_text_pos = "inline",
                display_callback = function(variable)
                    if #variable.value > 15 then
                        return " = " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " = " .. variable.value
                end,
            })

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
                        sourceMaps = true,
                        trace = true,
                    },
                }
            end

            -- Custom signs for DAP (red dot breakpoint)
            vim.fn.sign_define("DapBreakpoint", {
                text = "●", -- Red dot
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapBreakpointCondition", {
                text = "●", -- Conditional breakpoint
                texthl = "DapBreakpointCondition",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapBreakpointRejected", {
                text = "●",
                texthl = "DapBreakpointRejected",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapLogPoint", {
                text = "◆", -- Log point (diamond)
                texthl = "DapLogPoint",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapStopped", {
                text = "→", -- Current line arrow when debugging
                texthl = "DapStopped",
                linehl = "DapStopped",
                numhl = "DapStopped",
            })

            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000", bold = true }) -- Red
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#FF8800", bold = true }) -- Orange
            vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" }) -- Gray
            vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#00CCFF" }) -- Blue
            vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00FF00", bg = "#003300" })

            vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>dr", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>dk", function()
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
