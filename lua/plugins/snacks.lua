--=======================
-- // RETURN
--=======================

return {
    "folke/snacks.nvim",

    priority = 1000,
    lazy = false,
    opts = {
        notifier = {
            enabled = true,
            timeout = 3000,
        },

        bigfile = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        image = { enabled = false },

        explorer = { enabled = true },
    },
}
