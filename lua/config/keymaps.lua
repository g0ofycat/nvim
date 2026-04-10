--=======================
-- // KEYMAPS
--=======================

vim.g.mapleader = " "

--=======================
-- // PRESETS
--=======================

local keymap = vim.keymap.set

keymap("n", "e", "<cmd>enew<cr>", { desc = "New file" })
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
keymap("n", "<leader>fh", "<cmd>Telescope oldfiles<cr>", { desc = "Recently opened files" })
keymap("n", "<leader>fr", "<cmd>Telescope frecency<cr>", { desc = "Frecency/MRU" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find word" })
keymap("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Jump to bookmarks" })

keymap("n", "<leader>sl", function() require("persistence").load() end, { desc = "Open last session" })
keymap("n", "<leader>ss", function() require("persistence").select() end, { desc = "Select session" })

--=======================
-- // EXPLORER KEYBINDS
--=======================

keymap("n", "<leader>e", function()
	local snacks = require("snacks")
	local explorer_win = nil

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "snacks_picker_list" then
			explorer_win = win
			break
		end
	end

	if explorer_win then
		if vim.api.nvim_get_current_win() == explorer_win then
			vim.api.nvim_win_close(explorer_win, true)
		else
			vim.api.nvim_set_current_win(explorer_win)
		end
	else
		snacks.explorer()
	end
end, { desc = "Toggle explorer" })

--=======================
-- // TERMINAL KEYBINDS
--=======================

keymap('n', '<leader>t', ':split | terminal<CR>i', { desc = 'Open terminal' })
keymap('t', '<leader>t', '<C-\\><C-n>:q<CR>', { desc = 'Close terminal' })
keymap('t', '<Space>', '<Space>', { noremap = true, nowait = true })
keymap("t", "<esc>", [[<C-\><C-n>]], { silent = true, noremap = true })

--=======================
-- // CMAKE KEYBINDS
--=======================

keymap("n", "<leader>cm", function()
	vim.cmd("split | terminal cmake -S . -B build -G \"MinGW Makefiles\"")
end, { desc = "CMake configure" })

keymap("n", "<leader>cb", function()
	vim.cmd("split | terminal cmake --build build --target run")
end, { desc = "CMake build and run" })

--=======================
-- // WINDOW KEYBINDS
--=======================

keymap("n", "<C-z>", "u", { desc = "Undo" })
keymap("i", "<C-z>", "<C-o>u", { desc = "Undo" })

keymap("n", "<C-y>", "<C-r>", { desc = "Redo" })
keymap("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })

keymap("n", "<C-a>", "ggVG", { desc = "Select all" })
keymap("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

keymap("v", "<C-c>", '"+y', { desc = "Copy" })
keymap("n", "<C-c>", '"+yy', { desc = "Copy line" })

keymap("n", "<C-v>", '"+p', { desc = "Paste" })
keymap("i", "<C-v>", '<C-r>+', { desc = "Paste" })
keymap("v", "<C-v>", '"+p', { desc = "Paste" })

--=======================
-- // EDITOR KEYBINDS
--=======================

keymap('n', 'w', 'k', { noremap = true, silent = true })
keymap('n', 'a', 'h', { noremap = true, silent = true })
keymap('n', 's', 'j', { noremap = true, silent = true })
keymap('n', 'd', 'l', { noremap = true, silent = true })
keymap("n", "<C-n>", "<C-b>", { desc = "Move up one page" })
keymap("n", "<C-m>", "<C-f>", { desc = "Move down one page" })

keymap("i", "<C-s>", "<Esc>vib", { desc = "Select in surrounding" })

keymap("i", "<C-w>", "<Esc>viw", { desc = "Select current word" })
keymap("i", "<C-W>", "<Esc>viW", { desc = "Select current WORD" })

--=======================
-- // BUFFERLINE KEYBINDS
--=======================

keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next topbar buffer" })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous topbar buffer" })
keymap("n", "<leader>bd", ":bp|bd #<CR>", { desc = "Close current buffer" })
