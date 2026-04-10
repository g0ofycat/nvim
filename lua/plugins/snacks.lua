--=======================
-- // RETURN
--=======================

return {
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

		notifier = {
			enabled = true,
			timeout = 3000,
		},

		bigfile = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		image = { enabled = false },
	},
}
