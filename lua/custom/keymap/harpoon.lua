local harpoon = require("harpoon")

require("which-key").register({
	["<leader>f"] = { name = "[F]iles", _ = "which_key_ignore" },
})

harpoon:setup({})

vim.keymap.set("n", "<leader>fa", function()
	harpoon:list():append()
end, { desc = "[A]dd file to list" })

vim.keymap.set("n", "<leader>fm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Open file [M]enu" })

vim.keymap.set("n", "<leader>f1", function()
	harpoon:list():select(1)
end, { desc = "Select [1]st file in list" })

vim.keymap.set("n", "<leader>f2", function()
	harpoon:list():select(2)
end, { desc = "Select [2]nd file in list" })

vim.keymap.set("n", "<leader>f3", function()
	harpoon:list():select(3)
end, { desc = "Select [3]rd file in list" })

vim.keymap.set("n", "<leader>f4", function()
	harpoon:list():select(4)
end, { desc = "Select [4]th file in list" })
