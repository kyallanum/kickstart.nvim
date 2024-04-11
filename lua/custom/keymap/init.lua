require("custom.keymap.harpoon")

-- [[ Basic Keymaps ]]
require("which-key").register({
	["<leader>x"] = { name = "E[x]plore", _ = "which_key_ignore" },
})

-- Keymap for Explorer
vim.keymap.set("n", "<leader>xc", ":Explore<CR>", { desc = "at [C]urrent Directory" })
vim.keymap.set("n", "<leader>xo", ":Explore ~/.config/nvim/<CR>", { desc = "at C[o]nfig Directory" })
vim.keymap.set("n", "<leader>xh", ":Explore ~<CR>", { desc = " at [H]ome" })

-- [[ Buffer Keymaps ]]
require("which-key").register({
	["<leader>b"] = { name = "[B]uffer", _ = "which_key_ignore" },
})

vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "[D]elete" })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "[P]revious" })
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "[N]ext" })

-- Keymap for vertical movements
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- -- Remap to break out of comment
-- vim.keymap.set('i', '<C-CR>', "<Cmd>set formatoptions-=r<CR><CR><Cmd>set formatoptions+=r<CR>", { expr = false })
-- Use this one for Windows
vim.keymap.set("i", "<NL>", "<Cmd>set formatoptions-=r<CR><CR><Cmd>set formatoptions+=r<CR>", { expr = false })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move fos to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Clear highlighting on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
