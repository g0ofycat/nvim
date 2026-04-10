--=======================
-- // RETURN
--=======================

return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				[[ ▄           ▀▀ ▄       ]],
				[[ ████▄▀█▄ ██▀██ ███▄███▄]],
				[[ ██ ██ ██▄██ ██ ██ ██ ██]],
				[[▄██ ▀█  ▀█▀ ▄██▄██ ██ ▀█]],
			}

			require("alpha").setup(dashboard.opts)
		end,
	}
}
