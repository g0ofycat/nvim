--=======================
-- // RETURN
--=======================

return {
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
