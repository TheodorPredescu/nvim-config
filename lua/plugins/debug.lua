return {
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
            highlight_new_as_changed = true,

            show_stop_reason = true,
            commented = false,

            -- Display values beside every reference, not only the declaration.
            only_first_definition = false,
            all_references = true,

            -- Remove stale values while the program is running.
            clear_on_continue = true,

            virt_text_pos = "inline",

            display_callback = function(variable)
                local value = tostring(variable.value):gsub("%s+", " ")

                if #value > 40 then
                    value = value:sub(1, 40) .. "…"
                end

                return " = " .. value
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
                    name = "Launch in new page",
                    url = "http://localhost:4200",
                    webRoot = "${workspaceFolder}",
                    sourceMaps = true,
                    trace = true,
                },
                {
                    type = "pwa-chrome",
                    request = "attach",
                    name = "Attach to to current page (Chrome)",
                    port = 9222,
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
            text = "○",
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
        vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#FF0000" })
        vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#00CCFF" }) -- Blue
        vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00FF00", bg = "#003300" })

        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dr", dap.run_to_cursor)

        -- Eval var under cursor
        vim.keymap.set("n", "<leader>dk", function()
            ui.eval(nil, { enter = true })
        end)

        vim.keymap.set("n", "<leader>du", function()
            if dap.session() then
                ui.toggle()
            else
                vim.notify("No active DAP session", vim.log.levels.WARN)
            end
        end, { desc = "Toggle DAP UI (session only)" })

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
        dap.listeners.before.disconnect.dapui_config = function()
            ui.close()
        end
    end,
}
