--=======================
-- // STYLISTIC
--=======================

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.showtabline = 2
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.g.autoformat = false

vim.opt.list = true
vim.opt.listchars:append({
	space = '·',
	tab = '→ ',
	trail = '•',
	nbsp = '␣',
})

--=======================
-- // SWAP
--=======================

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

--=======================
-- // COMPILERS
--=======================

vim.env.CC = "gcc"
vim.env.CXX = "g++"

--=======================
-- // NO AUTO COMMENTS
--=======================

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },

	callback = function()
		vim.opt.formatoptions:remove("c")
		vim.opt.formatoptions:remove("r")
		vim.opt.formatoptions:remove("o")
	end,
})

--=======================
-- // MISC
--=======================

vim.g.luasnip_enable_jsregexp = false
