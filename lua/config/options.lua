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
