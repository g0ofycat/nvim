--=======================
-- // RETURN
--=======================

return {
	{
		"mason-org/mason.nvim",
		cmd    = "Mason",
		config = true,
	},

	{
		"neovim/nvim-lspconfig",
		event        = { "BufReadPost", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths        = false,
								diagnosticMode         = "openFilesOnly",
								useLibraryCodeForTypes = false,
								typeCheckingMode       = "basic",
							},
						},
					},
				},

				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints                        = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints                = false,
								includeInlayVariableTypeHints                         = false,
								includeInlayPropertyDeclarationTypeHints              = false,
								includeInlayFunctionLikeReturnTypeHints               = false,
								includeInlayEnumMemberValueHints                      = false,
							},
						},
					},
				},

				lua_ls = {
					settings = {
						Lua = {
							runtime     = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace   = { checkThirdParty = false },
						},
					},
				},

				clangd = {
					cmd = {
						"clangd",
						"-j=4",
						"--completion-style=bundled",
						"--header-insertion=never",
						"--background-index-priority=low",
						"--pch-storage=memory",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
						"--limit-results=20",
					},
					init_options = {
						clangdFileStatus     = false,
						usePlaceholders      = true,
						completeUnimported   = false,
						semanticHighlighting = false,
					},
				},

				texlab = {
					settings = {
						texlab = {
							build = {
								executable = "latexmk",
								args       = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
								onSave     = true,
							},
							chktex        = { onOpenAndSave = true },
							forwardSearch = {
								executable = "SumatraPDF",
								args       = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" },
							},
						},
					},
				},
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for name, opts in pairs(servers) do
				opts.capabilities = capabilities
				vim.lsp.config(name, opts)
				vim.lsp.enable(name)
			end

			--=======================
			-- // DIAGNOSTICS
			--=======================

			vim.diagnostic.config({
				update_in_insert = false,
				virtual_text     = { spacing = 4, prefix = "●" },
				severity_sort    = true,
				underline        = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN]  = " ",
						[vim.diagnostic.severity.HINT]  = " ",
						[vim.diagnostic.severity.INFO]  = " ",
					},
				},
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			--=======================
			-- // LSP KEYMAPS
			--=======================

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts)
					vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    opts)
					vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr",         vim.lsp.buf.references,     opts)
					vim.keymap.set("n", "K",          vim.lsp.buf.hover,          opts)
					vim.keymap.set("i", "<C-k>",      vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    opts)
					vim.keymap.set("n", "<leader>f",  function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},

	--=======================
	-- // COMPLETION
	--=======================

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version      = "1.*",

		opts = {
			keymap = {
				preset  = "none",
				[","]   = { "select_next", "fallback" },
				["."]   = { "select_prev", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
			},
			appearance = { nerd_font_variant = "normal" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
				list = {
					selection = { preselect = true, auto_insert = false },
				},
			},
			sources = {
				default            = { "lsp", "path", "snippets", "buffer" },
				min_keyword_length = 0,
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},

		opts_extend = { "sources.default" },
	},

	--=======================
	-- // FORMATTING
	--=======================

	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd   = { "ConformInfo" },
		keys  = {
			{
				"<S-A-f>",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					cpp        = { "clang-format" },
					c          = { "clang-format" },
					python     = { "black" },
					luau       = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
				},
				formatters = {
					["clang-format"] = { prepend_args = { "--style={IndentWidth: 4, UseTab: Never}" } },
					black            = { prepend_args = { "--line-length", "120" } },
					stylua           = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } },
					prettier         = { prepend_args = { "--tab-width", "4", "--use-tabs", "false" } },
				},
			})
		end,
	},
}
