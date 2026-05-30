--=======================
-- // RETURN
--=======================

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local colors = {
			black  = '#080808',
			white  = '#c6c6c6',
			bright = '#e8e8e8',
			grey   = '#303030',
			mid    = '#555555',
		}

		local bubbles_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.bright },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white },
			},
			insert  = { a = { fg = colors.black, bg = colors.white } },
			visual  = { a = { fg = colors.black, bg = colors.mid   } },
			replace = { a = { fg = colors.black, bg = colors.mid   } },
			inactive = {
				a = { fg = colors.white, bg = colors.black },
				b = { fg = colors.white, bg = colors.black },
				c = { fg = colors.white },
			},
		}

		require('lualine').setup {
			options = {
				theme                = bubbles_theme,
				component_separators = '',
				section_separators   = { left = '', right = '' },
			},
			sections = {
				lualine_a = {
					{ 'mode', separator = { left = '' }, right_padding = 2 }
				},
				lualine_b = {
					'filename',
					'branch',
					{
						'diff',
						source = diff_source,
						symbols = {
							added = '+',
							modified = '~',
							removed = '-',
						},
					}
				},
				lualine_c = { '%=' },
				lualine_x = {},
				lualine_y = { 'filetype', 'progress' },
				lualine_z = {
					{ 'location', separator = { right = '' }, left_padding = 2 }
				},
			},
			inactive_sections = {
				lualine_a = { 'filename' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'location' },
			},
			tabline    = {},
			extensions = {},
		}
	end,
}
