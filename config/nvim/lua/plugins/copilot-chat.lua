return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    system_prompt = "あなたは優秀なプログラミングアシスタントです。常に日本語で回答してください。",
  },
  keys = {
    {
      "<leader>ac",
      function()
        require("CopilotChat").open()
        vim.defer_fn(function()
          vim.cmd("startinsert")
        end, 100)
      end,
      desc = "CopilotChat Open",
    },
  },
}
