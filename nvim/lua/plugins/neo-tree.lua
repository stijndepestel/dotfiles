return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["sg"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type ~= "directory" then
            path = vim.fn.fnamemodify(path, ":h")
          end
          require("fzf-lua").live_grep({ search_dirs = { path } })
        end,
      },
    },
  },
}
