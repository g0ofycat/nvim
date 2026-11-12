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
	Normal       = { fg = "#FFFFFF", bg = "#1E1E1E" },
	NormalFloat  = { fg = "#FFFFFF", bg = "#1E1E1E" },
	NormalNC     = { fg = "#FFFFFF", bg = "#1E1E1E" },

	LineNr       = { fg = "#666666", bg = "#1E1E1E" },
	CursorLineNr = { fg = "#FFFFFF", bg = "#2A2A2A" },
	CursorLine   = { bg = "#2A2A2A" },

	SignColumn   = { fg = "#FFFFFF", bg = "#1E1E1E" },
	FoldColumn   = { fg = "#666666", bg = "#1E1E1E" },

	VertSplit    = { fg = "#404040", bg = "#1E1E1E" },
	WinSeparator = { fg = "#404040", bg = "#1E1E1E" },

	StatusLine   = { fg = "#FFFFFF", bg = "#2A2A2A" },
	StatusLineNC = { fg = "#777777", bg = "#1E1E1E" },

	TabLine      = { fg = "#AAAAAA", bg = "#1E1E1E" },
	TabLineFill  = { bg = "#1E1E1E" },
	TabLineSel   = { fg = "#FFFFFF", bg = "#333333" },

	Pmenu        = { fg = "#FFFFFF", bg = "#252525" },
	PmenuSel     = { fg = "#FFFFFF", bg = "#333333" },

	Search       = { fg = "#000000", bg = "#FFFFFF" },
	IncSearch    = { fg = "#000000", bg = "#AAAAAA" },

	Visual       = { bg = "#404040" },
	MatchParen   = { fg = "#FFFFFF", bg = "#404040" },

	SnacksPickerNormal = { fg = "#FFFFFF", bg = "#1E1E1E" },
	SnacksPickerFile = { fg = "#FFFFFF" },
	SnacksPickerDirectory = { fg = "#FFFFFF" },
	SnacksPickerDir = { fg = "#FFFFFF" },
	SnacksPickerTree = { fg = "#FFFFFF" },
	SnacksPickerPathIgnored = { fg = "#AAAAAA" },
	SnacksPickerPathHidden = { fg = "#AAAAAA" },
	SnacksPickerGitStatus = { fg = "#FFFFFF" },
	SnacksPickerGitStatusAdded = { fg = "#FFFFFF" },
	SnacksPickerGitStatusModified = { fg = "#FFFFFF" },
	SnacksPickerGitStatusDeleted = { fg = "#FFFFFF" },
	SnacksPickerGitStatusRenamed = { fg = "#FFFFFF" },
	SnacksPickerGitStatusCopied = { fg = "#FFFFFF" },
	SnacksPickerGitStatusUntracked = { fg = "#FFFFFF" },
	SnacksPickerGitStatusIgnored = { fg = "#FFFFFF" },
	SnacksPickerGitStatusUnmerged = { fg = "#FFFFFF" },
	SnacksPickerGitStatusStaged = { fg = "#FFFFFF" },
	Comment      = { fg = "#AAAAAA" },
	Identifier   = { fg = "#FFFFFF" },
	Statement    = { fg = "#FFFFFF" },
	Type         = { fg = "#FFFFFF" },
	Constant     = { fg = "#FFFFFF" },
	Special      = { fg = "#FFFFFF" },
	String       = { fg = "#FFFFFF" },
	Function     = { fg = "#FFFFFF" },
}

for group, colors in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, colors)
end
