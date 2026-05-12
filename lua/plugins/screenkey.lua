return {
	"NStefan002/screenkey.nvim",
	lazy = false,
	config = function()
		local screenkey = require("screenkey")

		screenkey.setup({
			win_opts = {
				row = vim.o.lines - vim.o.cmdheight - 1,
				col = vim.o.columns,
				relative = "editor",
				anchor = "SE",
				width = 20,
				height = 1,
				border = "none",
			},
			winblend = 80,
			hl_groups = {
				["screenkey.hl.key"] = { link = "Comment" },
				["screenkey.hl.map"] = { link = "Comment" },
				["screenkey.hl.sep"] = { link = "Comment" },
			},
			compress_after = 0,
			clear_after = 1,
			separator = "  ",
			group_mappings = false,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.defer_fn(function()
					vim.cmd("Screenkey")
				end, 100)
			end,
		})
	end,
}
