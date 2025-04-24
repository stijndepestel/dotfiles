-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Tmux navigator.
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Navigate Left" })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Navigate Right" })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Navigate Up" })

-- Do not move deleted contents with "d" to the default register aka the clipboard.
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, silent = true })
