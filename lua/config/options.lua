--=======================
-- // STYLISTIC
--=======================

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.showtabline = 2
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.signcolumn = "yes"
vim.g.autoformat = false

vim.opt.list = true

vim.opt.listchars:append({
	space = "·",
	tab   = "→ ",
	trail = "•",
	nbsp  = "␣",
})

--=======================
-- // SWAP
--=======================

vim.opt.swapfile    = false
vim.opt.backup      = false
vim.opt.writebackup = false

--=======================
-- // COMPILERS
--=======================

vim.env.CC  = "gcc"
vim.env.CXX = "g++"

--=======================
-- // NO AUTO COMMENTS
--=======================

vim.api.nvim_create_autocmd("FileType", {
	pattern  = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

--=======================
-- // MISC
--=======================

vim.cmd("filetype plugin indent on")

--=======================
-- // project.nvim replacement
--=======================

local markers = { '.git', 'Makefile', 'makefile', 'package.json', '.gitignore', 'CMakeLists.txt', 'README.md' }

local function find_root(path)
	local dir = vim.fs.dirname(path)

	while dir do
		for _, marker in ipairs(markers) do
			if vim.uv.fs_stat(dir .. "/" .. marker) then
				return dir
			end
		end

		local parent = vim.fs.dirname(dir)
		if parent == dir then break end
		dir = parent
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(args)
		local path = vim.api.nvim_buf_get_name(args.buf)
		if path == "" then return end

		local root = find_root(path)
		if root then
			vim.cmd.cd(root)
		end
	end,
})

--=======================
-- colorscheme
--=======================

vim.cmd("syntax off")

vim.cmd("highlight clear")

local highlights = {
	Normal       = { fg = "#EEEEEE", bg = "#181818" },
	NormalFloat  = { fg = "#EEEEEE", bg = "#202020" },
	NormalNC     = { fg = "#CCCCCC", bg = "#181818" },

	LineNr       = { fg = "#777777", bg = "#181818" },
	CursorLineNr = { fg = "#FFFFFF", bg = "#282828" },
	CursorLine   = { bg = "#282828" },

	SignColumn   = { fg = "#CCCCCC", bg = "#181818" },
	FoldColumn   = { fg = "#888888", bg = "#181818" },

	VertSplit    = { fg = "#444444", bg = "#181818" },
	WinSeparator = { fg = "#444444", bg = "#181818" },

	StatusLine   = { fg = "#EEEEEE", bg = "#303030" },
	StatusLineNC = { fg = "#999999", bg = "#202020" },

	TabLine      = { fg = "#BBBBBB", bg = "#202020" },
	TabLineFill  = { bg = "#181818" },
	TabLineSel   = { fg = "#FFFFFF", bg = "#383838" },

	Pmenu        = { fg = "#EEEEEE", bg = "#252525" },
	PmenuSel     = { fg = "#FFFFFF", bg = "#444444" },

	Search       = { fg = "#181818", bg = "#DDDDDD" },
	IncSearch    = { fg = "#181818", bg = "#BBBBBB" },

	Visual       = { bg = "#404040" },
	MatchParen   = { fg = "#FFFFFF", bg = "#484848" },

	Comment      = { fg = "#AAAAAA" },
	Identifier   = { fg = "#EEEEEE" },
	Statement    = { fg = "#EEEEEE" },
	Type         = { fg = "#EEEEEE" },
	Constant     = { fg = "#EEEEEE" },
	Special      = { fg = "#EEEEEE" },
	String       = { fg = "#EEEEEE" },
	Function     = { fg = "#EEEEEE" },

	SnacksPickerDirectory     = { fg = "#EEEEEE" },
	SnacksPickerDir           = { fg = "#EEEEEE" },
	SnacksPickerIcon          = { fg = "#EEEEEE" },
	SnacksPickerTree          = { fg = "#888888" },
	SnacksPickerDirectoryIcon = { fg = "#EEEEEE" },
	SnacksPickerDirIcon       = { fg = "#EEEEEE" },
	SnacksPickerIconDirectory = { fg = "#EEEEEE" },

	SnacksPickerListTitle  = { fg = "#EEEEEE" },
	SnacksPickerInput      = { fg = "#EEEEEE" },
	SnacksPickerPrompt     = { fg = "#EEEEEE" },
	SnacksPickerToggle     = { fg = "#EEEEEE" },
	SnacksPickerToggleOn   = { fg = "#EEEEEE" },
	SnacksPickerToggleOff  = { fg = "#AAAAAA" },

	Directory          = { fg = "#EEEEEE" },
	NvimTreeFolderIcon = { fg = "#EEEEEE" },
}

for group, colors in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, colors)
end
