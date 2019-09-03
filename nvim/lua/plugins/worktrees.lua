local createNewWorkTree = function(opts)
  local gw = require("git-worktree")
  local dpqaRoot = os.getenv("WORKTREE_ROOT_DIR")
  opts = opts or {}

  if dpqaRoot == nil then
    print("WORKTREE_ROOT_DIR not set")
    return
  end
  
  local branch = vim.fn.input("Branch name > ")
  if branch == "" then
    return
  end
  
  gw.create_worktree(dpqaRoot .. "/branches/" .. branch, branch, "origin")
end


return {
  "ThePrimeagen/git-worktree.nvim",
  config = function()
    require("telescope").load_extension("git_worktree")
    vim.keymap.set("n", "<leader>gwl", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>")
    vim.keymap.set("n", "<leader>gwa", createNewWorkTree)

  end
}
