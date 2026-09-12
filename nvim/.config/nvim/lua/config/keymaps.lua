-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 1. Familiar Save (Ctrl + S)
-- Works in Normal, Insert, and Visual mode
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- 2. Escape Insert Mode Quickly
-- Typing 'jk' or 'jj' quickly will exit insert mode (so you don't have to reach for ESC)
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "jj", "<ESC>", { desc = "Escape insert mode" })

-- 3. Familiar Select All (Ctrl + A)
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- 4. Intuitive Buffer (Tab) Navigation
-- Move between open files just like a web browser
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer (tab)" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer (tab)" })

-- 5. Close buffer easily with Leader + x (in addition to LazyVim's Leader + c)
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- 6. Floating Terminal (Lebih mudah dipencet)
-- Terminal akan otomatis terbuka di dalam folder tempat file saat ini berada
map("n", "<C-t>", function()
  local current_dir = vim.fn.expand("%:p:h")
  if current_dir == "" or not (vim.uv or vim.loop).fs_stat(current_dir) then
    current_dir = vim.fn.getcwd()
  end
  -- Menggunakan ID tetap agar Snacks tidak membuat terminal baru terus-menerus
  Snacks.terminal.toggle(nil, { cwd = current_dir, id = "caelestia_term" })
end, { desc = "Toggle Terminal (Current Dir)" })

-- Gunakan escape code <C-\><C-n> agar Neovim benar-benar keluar dari mode terminal sebelum menutupnya
map("t", "<C-t>", "<C-\\><C-n><cmd>close<cr>", { desc = "Hide Terminal" })
