--=======================
-- // RETURN
--=======================

return {
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
