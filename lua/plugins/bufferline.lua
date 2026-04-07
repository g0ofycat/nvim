--=======================
-- // RETURN
--=======================

return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        highlights = {
            fill = { bg = "NONE" },
            background = { bg = "NONE" },
            tab = { bg = "NONE" },
            tab_selected = { bg = "NONE" },
            tab_separator = { bg = "NONE" },
            tab_separator_selected = { bg = "NONE" },
            buffer_visible = { bg = "NONE" },
            buffer_selected = { bg = "NONE" },
            separator = { bg = "NONE" },
            separator_selected = { bg = "NONE" },
            separator_visible = { bg = "NONE" },
            indicator_selected = { bg = "NONE" },
            offset_separator = { bg = "NONE" },
        },
        options = {
            mode = "buffers",
            separator_style = "none",
            always_show_bufferline = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level)
                local icons = { error = " ", warning = " " }
                return icons[level] and (icons[level] .. count) or ""
            end,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = false,
                },
            },
        },
    },
}
