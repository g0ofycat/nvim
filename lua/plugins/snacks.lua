--=======================
-- // RETURN
--=======================

return {
	"folke/snacks.nvim",

	dependencies = {
		{
			"nvim-tree/nvim-web-devicons",
			opts = {
				color_icons = false,
				override = {
					default_icon = {
						icon = "",
						color = "#FFFFFF",
						cterm_color = "15",
						name = "Default",
					},
				},
			},
		},
	},
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			sources = {
				explorer = {
					enabled = true,
					hidden = true,
					ignored = true,
				},
			},
		},

		dashboard = {
			enabled = true,
			preset = {
				header = [[
▄           ▀▀ ▄       
████▄▀█▄ ██▀██ ███▄███▄
██ ██ ██▄██ ██ ██ ██ ██
██ ▀█  ▀█▀ ▄██▄██ ██ ▀█]],
			},
		},

		notifier = {
			enabled = true,
			timeout = 5000,
		},

		lazygit = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		image = { enabled = false },
	},
}
