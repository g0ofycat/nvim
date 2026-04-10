--=======================
-- // RETURN
--=======================

return {
	"shasherazi/wpm-nvim",
	dependencies = { "MunifTanjim/nui.nvim" },

	config = function()
		local wpm = require("wpm")
		wpm.setup({
			interval = 1000,
			threshold = 10,
			refresh_rate = 500,
		})
	end,
}
