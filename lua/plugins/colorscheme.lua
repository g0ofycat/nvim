--=======================
-- // RETURN
--=======================

return {
	"ember-theme/nvim",
	name = "ember",
	priority = 1000,
	config = function()
		require("ember").setup({
			variant = "ember-light",
		})
		vim.cmd("colorscheme ember")
	end,
}
