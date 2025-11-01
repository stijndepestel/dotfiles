return {
  {
    "LazyVim/LazyVim",
    init = function()
      if vim.fn.hostname() == "Stijns-MacBook-Pro.local" then
        vim.g.autoformat = false
      end
    end,
  },
}
