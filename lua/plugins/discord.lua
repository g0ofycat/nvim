--=======================
-- // RETURN
--=======================

return {
	"vyfor/cord.nvim",
	---@type CordConfig
	opts = {
		variables = {
			line = function() return vim.api.nvim_win_get_cursor(0)[1] end,
			max_lines = function() return vim.api.nvim_buf_line_count(0) end,
		},
		text = {
			editing = 'Editing ${filename} [Line ${line}:${max_lines}]',
			viewing = 'Viewing ${filename} [Line ${line}:${max_lines}]',
		}
	}
}
