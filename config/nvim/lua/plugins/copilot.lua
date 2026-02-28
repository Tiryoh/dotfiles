--- Tab to accept Copilot, handled in plugins/blink.lua
--- See: lua/plugins/blink.lua for more details
return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      keymap = {
        accept = false,
      },
    },
  },
}
