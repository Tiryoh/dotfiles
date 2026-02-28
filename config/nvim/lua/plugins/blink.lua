-- accept ai suggestions and code completions with tab.
-- ctrl-p/n will jump to the next/prev suggestion, and tab will always accept the current one.
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = {
        "select_and_accept",
        LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
        "fallback",
      },
    },
  },
}
