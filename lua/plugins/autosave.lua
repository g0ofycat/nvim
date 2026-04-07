--=======================
-- // RETURN
--=======================

return {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
        enabled = true,
        execution_message = {
            enabled = false,
        },
        trigger_events = {
            immediate_save = { "BufLeave", "FocusLost" },
            defer_save = { "InsertLeave", "TextChanged" },
        },
        debounce_delay = 100,
    },
}
