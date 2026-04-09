--=======================
-- // RETURN
--=======================

return {
    "shasherazi/wpm-nvim",
    dependencies = { "MunifTanjim/nui.nvim" },

    config = function()
        local wpm = require("wpm")
        wpm.setup({
            interval = 1000,
            threshold = 50,
            refresh_rate = 100,
        })
    end,
}
