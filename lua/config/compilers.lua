--=======================
-- // MAIN
--=======================

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },

	callback = function()
		local keymap = vim.keymap.set
		local buf = vim.api.nvim_get_current_buf()

		keymap("n", "<leader>r", function()
			vim.cmd("w")

			local file = vim.fn.expand("%:p")
			local output = vim.fn.expand("%:p:r")
			local ft = vim.bo.filetype

			local compile_cmd

			if ft == "c" then
				compile_cmd = string.format("gcc '%s' -o '%s' && '%s'", file, output, output)
			else
				compile_cmd = string.format("g++ '%s' -o '%s' && '%s'", file, output, output)
			end

			vim.cmd("split | terminal " .. compile_cmd)
		end, { buffer = buf, desc = "Compile and Run" })
	end,
})
