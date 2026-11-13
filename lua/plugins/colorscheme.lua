--=======================
-- // RETURN
--=======================

return {
	"g0ofycat/ember-light",
	priority = 1000,
	config = function()
		require("ember-light").setup()
		vim.cmd.colorscheme("ember-light")
	end
}
