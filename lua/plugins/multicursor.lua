--=======================
-- // RETURN
--=======================

return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	event  = "VeryLazy",

	config = function()
		local mc  = require("multicursor-nvim")
		local set = vim.keymap.set
		mc.setup()

		set({ "n", "x" }, "<up>",           function() mc.lineAddCursor(-1) end)
		set({ "n", "x" }, "<down>",         function() mc.lineAddCursor(1) end)
		set({ "n", "x" }, "<leader><up>",   function() mc.lineSkipCursor(-1) end)
		set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)
		set({ "n", "x" }, "<leader>n",      function() mc.matchAddCursor(1) end)
		set({ "n", "x" }, "<leader>s",      function() mc.matchSkipCursor(1) end)
		set({ "n", "x" }, "<leader>N",      function() mc.matchAddCursor(-1) end)
		set({ "n", "x" }, "<leader>S",      function() mc.matchSkipCursor(-1) end)
		set("n",          "<c-leftmouse>",  mc.handleMouse)
		set("n",          "<c-leftdrag>",   mc.handleMouseDrag)
		set("n",          "<c-leftrelease>",mc.handleMouseRelease)
		set({ "n", "x" }, "<c-q>",          mc.toggleCursor)

		mc.addKeymapLayer(function(layerSet)
			layerSet({ "n", "x" }, "<left>",      mc.prevCursor)
			layerSet({ "n", "x" }, "<right>",     mc.nextCursor)
			layerSet({ "n", "x" }, "<leader>x",   mc.deleteCursor)
			layerSet("n",          "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		local hl = vim.api.nvim_set_hl
		local highlights = {
			MultiCursorCursor         = { reverse = true },
			MultiCursorVisual         = { link = "Visual" },
			MultiCursorSign           = { link = "SignColumn" },
			MultiCursorMatchPreview   = { link = "Search" },
			MultiCursorDisabledCursor = { reverse = true },
			MultiCursorDisabledVisual = { link = "Visual" },
			MultiCursorDisabledSign   = { link = "SignColumn" },
		}
		for name, opts in pairs(highlights) do
			hl(0, name, opts)
		end
	end,
}
