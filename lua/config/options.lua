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
	Normal       = { fg = "#FFFFFF", bg = "#000000" },
	NormalFloat  = { fg = "#FFFFFF", bg = "#000000" },
	NormalNC     = { fg = "#FFFFFF", bg = "#000000" },

	LineNr       = { fg = "#666666", bg = "#000000" },
	CursorLineNr = { fg = "#FFFFFF", bg = "#151515" },
	CursorLine   = { bg = "#151515" },

	SignColumn   = { fg = "#FFFFFF", bg = "#000000" },
	FoldColumn   = { fg = "#666666", bg = "#000000" },

	VertSplit    = { fg = "#333333", bg = "#000000" },
	WinSeparator = { fg = "#333333", bg = "#000000" },

	StatusLine   = { fg = "#FFFFFF", bg = "#151515" },
	StatusLineNC = { fg = "#777777", bg = "#000000" },

	TabLine      = { fg = "#AAAAAA", bg = "#000000" },
	TabLineFill  = { bg = "#000000" },
	TabLineSel   = { fg = "#FFFFFF", bg = "#222222" },

	Pmenu        = { fg = "#FFFFFF", bg = "#111111" },
	PmenuSel     = { fg = "#FFFFFF", bg = "#333333" },

	Search       = { fg = "#000000", bg = "#FFFFFF" },
	IncSearch    = { fg = "#000000", bg = "#AAAAAA" },

	Visual       = { bg = "#333333" },
	MatchParen   = { fg = "#FFFFFF", bg = "#333333" },

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
