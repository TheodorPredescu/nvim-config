vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
})

require("mini.icons").setup()
-- require("mini.pairs").setup()

local wide_picker = {
    window = {
        config = {
            width = math.min(220, vim.o.columns - 4),
        },
    },
}
local pick = require("mini.pick")
pick.setup()
vim.keymap.set("n", "<leader>f", function()
    pick.builtin.files({ tool = "fd" }, wide_picker)
end)

vim.keymap.set("n", "<leader>bl", function()
    pick.builtin.buffers({}, wide_picker)
end, { desc = "Buffers" })

local animate = require("mini.animate")
local mouse_scrolled = false

for _, direction in ipairs({ "Up", "Down" }) do
    local key = "<ScrollWheel" .. direction .. ">"

    vim.keymap.set({ "", "i" }, key, function()
        mouse_scrolled = true
        return key
    end, { expr = true })
end

animate.setup(
{

  scroll = {
    enable = true,

    timing = animate.gen_timing.linear({
        duration = 25,
        unit = "total",
    }),
    subscroll = animate.gen_subscroll.equal({
         predicate = function(total_scroll)
             if mouse_scrolled then
                 mouse_scrolled = false
                 return false
             end

             return total_scroll > 1
         end,
     }),
  },

  cursor = { enable = false },
  resize = { enable = false },
  open = { enable = false },
  close = { enable = false },
})

local highlighters = {}

local keywords = {
    TODO = "Todo",
    FIXME = "Fixme",
    FIX = "Fixme",
    BUG = "Fixme",
    HACK = "Hack",
    WARN = "Hack",
    WARNING = "Hack",
    NOTE = "Note",
    INFO = "Note",
    PERF = "Note",
    OPTIMIZE = "Note",
    XXX = "Hack",
}

for keyword, group in pairs(keywords) do
    highlighters[keyword:lower()] = {
        pattern = "%f[%w]()" .. keyword .. "()%f[%W]",
        group = "MiniHipatterns" .. group,
    }
end

require("mini.hipatterns").setup({
    highlighters = highlighters,
})
