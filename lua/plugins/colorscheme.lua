--=======================
-- // RETURN
--=======================

return {
	"kdheepak/monochrome.nvim",
	dependencies = "rktjmp/lush.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		vim.cmd.colorscheme("monochrome")
	end,
}
