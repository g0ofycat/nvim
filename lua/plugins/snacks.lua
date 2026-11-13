--=======================
-- // RETURN
--=======================

return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"folke/snacks.nvim",
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
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			words = { enabled = true },
		},
	},
}
