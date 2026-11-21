vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { space = "·", tab = "→ ", trail = "•", nbsp = "␣" }
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.g.loaded_matchit = 1
vim.env.CC = "gcc"
vim.env.CXX = "g++"

vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/g0ofycat/ember-light",
	"https://github.com/sphamba/smear-cursor.nvim",
}, { confirm = false })

local Snacks = require("snacks")

Snacks.setup({
	picker = { sources = { explorer = { enabled = true, hidden = true, ignored = true } } },
	explorer = {},
	dashboard = {
		preset = {
			header = "neovim",
			keys = {
				{ key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
				{ key = "n", desc = "New File", action = ":ene | startinsert" },
				{ key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
				{ key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
				{ key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
				{ key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
				{ key = "q", desc = "Quit", action = ":qa" },
			},
		},

		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
})

require("ember-light").setup()
vim.cmd.colorscheme("ember-light")

require("smear_cursor").setup({})

local autosave = vim.uv.new_timer()
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
	callback = function(ev)
		local buf = ev.buf
		if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" or not vim.bo[buf].modified then
			return
		end
		autosave:stop()
		autosave:start(100, 0, vim.schedule_wrap(function()
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
				vim.api.nvim_buf_call(buf, function() vim.cmd.write() end)
			end
		end))
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
})

local markers = { ".git", "Makefile", "makefile", "package.json", ".gitignore", "CMakeLists.txt", "README.md" }
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(ev)
		if vim.api.nvim_buf_get_name(ev.buf) == "" then return end
		local root = vim.fs.root(ev.buf, markers)
		if root then vim.cmd.cd(root) end
	end,
})

local map = vim.keymap.set
local bin = vim.fn.stdpath("data") .. "/mason/bin/"

vim.lsp.config("*", { root_markers = { ".git" } })

vim.lsp.config("clangd", {
	cmd = {
		"clangd", "-j=4", "--completion-style=bundled", "--header-insertion=never",
		"--background-index-priority=low", "--pch-storage=memory",
		"--function-arg-placeholders", "--fallback-style=llvm", "--limit-results=20",
	},
	root_markers = { ".clangd", "compile_commands.json", "CMakeLists.txt", ".git" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	init_options = {
		clangdFileStatus = false,
		usePlaceholders = true,
		completeUnimported = false,
		semanticHighlighting = false,
	},
})

vim.lsp.config("lua_ls", {
	cmd = { bin .. "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
		},
	},
})

vim.lsp.config("pyright", {
	cmd = { bin .. "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	settings = {
		python = {
			analysis = {
				autoSearchPaths = false,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = false,
				typeCheckingMode = "basic",
			},
		},
	},
})

vim.lsp.config("ts_ls", {
	cmd = { bin .. "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", ".git" },
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayVariableTypeHints = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayFunctionLikeReturnTypeHints = false,
				includeInlayEnumMemberValueHints = false,
			},
		},
	},
})

vim.lsp.config("texlab", {
	cmd = { bin .. "texlab" },
	filetypes = { "tex", "bib" },
	root_markers = { ".latexmkrc", ".git" },
	settings = {
		texlab = {
			build = {
				executable = "latexmk",
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
				onSave = true,
			},
			chktex = { onOpenAndSave = true },
		},
	},
})

for _, server in ipairs({ "clangd", "lua_ls", "pyright", "ts_ls", "texlab" }) do
	vim.lsp.enable(server)
end

vim.diagnostic.config({
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	severity_sort = true,
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	float = { border = "rounded", source = true, header = "", prefix = "" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "gr", vim.lsp.buf.references, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
	end,
})

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find file" })
map("n", "<leader>fh", function() Snacks.picker.recent() end, { desc = "Recently opened files" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Frecency / MRU" })
map("n", "<leader>fG", function() Snacks.picker.grep() end, { desc = "Find word in workspace" })
map("n", "<leader>fg", function() Snacks.picker.lines() end, { desc = "Find word in current buffer" })
map("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Jump to bookmarks" })
map("n", "<leader>c", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Open nvim config" })

map("n", "<leader>e", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "snacks_picker_list" then
			if vim.api.nvim_get_current_win() == win then
				vim.api.nvim_win_close(win, true)
			else
				vim.api.nvim_set_current_win(win)
			end
			return
		end
	end
	Snacks.explorer()
end, { desc = "Toggle explorer" })

map("n", "<leader>t", "<cmd>split | terminal<cr>i", { desc = "Open terminal" })
map("t", "<leader>t", "<C-\\><C-n><cmd>q<cr>", { desc = "Close terminal" })
map("t", "<Space>", "<Space>", { noremap = true, nowait = true })
map("t", "<Esc>", [[<C-\><C-n>]], { silent = true, noremap = true })

map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("v", "<C-c>", '"+y', { desc = "Copy" })
map("n", "<C-c>", '"+yy', { desc = "Copy line" })
map("n", "<A-v>", '"+p', { desc = "Paste" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-v>", '"+p', { desc = "Paste" })
map("n", ".", "<C-b>", { desc = "Move up one page" })
map("n", ",", "<C-f>", { desc = "Move down one page" })
map("i", "<C-s>", "<Esc>vib", { desc = "Select in surrounding" })
map("i", "<C-w>", "<Esc>viw", { desc = "Select current word" })
map("i", "<C-W>", "<Esc>viW", { desc = "Select current WORD" })

map("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "<C-e>", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostics" })
