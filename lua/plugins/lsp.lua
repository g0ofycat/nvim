--=======================
-- // RETURN
--=======================

return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPost", "BufNewFile" },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = { "documentation", "detail", "additionalTextEdits" },
            }

            local default_opts = {
                capabilities = capabilities,
                flags = {
                    debounce_text_changes = 500,
                    allow_incremental_sync = true,
                },
            }

            local servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = false,
                                typeCheckingMode = "basic",
                            },
                        },
                    },
                },
                tsserver = {
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
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                luau_lsp = {},
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
                        "--query-driver=C:\\winlibs-x86_64-cpp\\mingw64\\bin\\x86_64-w64-mingw32-g++.exe",
                    },
                    init_options = {
                        clangdFileStatus = false,
                        usePlaceholders = true,
                        completeUnimported = false,
                        semanticHighlighting = false,
                    },
                },
                texlab = {
                    settings = {
                        texlab = {
                            build = {
                                executable = "latexmk",
                                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                                onSave = true,
                            },
                            chktex = {
                                onOpenAndSave = true,
                            },
                            forwardSearch = {
                                executable = "SumatraPDF",
                                args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" },
                            },
                        },
                    },
                },
            }

            for name, opts in pairs(servers) do
                vim.lsp.config[name] = vim.tbl_deep_extend("force", default_opts, opts)
            end

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ft_servers = {
                        python = { "pyright" },
                        lua = { "lua_ls" },
                        cpp = { "clangd" },
                        c = { "clangd" },
                        typescript = { "tsserver" },
                        javascript = { "tsserver" },
                    }

                    for _, server in ipairs(ft_servers[args.match] or {}) do
                        vim.lsp.enable(server)
                    end
                end,
            })

            vim.diagnostic.config({
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                },
                severity_sort = true,
                underline = true,
                signs = true,
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }

                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                end,
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            { "L3MON4D3/LuaSnip", event = "InsertEnter" },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            nvim_lsp_signature_help = "[Sig]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                completion = {
                    autocomplete = {
                        require("cmp.types").cmp.TriggerEvent.TextChanged,
                    },
                    completeopt = "menu,menuone,noinsert",
                },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "ConformInfo" },
        keys = {
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
                    cpp = { "clang-format" },
                    c = { "clang-format" },
                    python = { "black" },
                    lua = { "stylua" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                },
                formatters = {
                    ["clang-format"] = {
                        prepend_args = { "--style={IndentWidth: 4, UseTab: Never}" },
                    },
                    black = {
                        prepend_args = { "--line-length", "120" },
                    },
                    stylua = {
                        prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                    },
                    prettier = {
                        prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                    },
                },
            })
        end,
    },

    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = {
            {
                "<leader>d",
                function()
                    require("neogen").generate()
                end,
                desc = "Generate documentation",
            },
        },
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    cpp = {
                        template = {
                            annotation_convention = "doxygen_triple_slash",
                        },
                    },
                    c = {
                        template = {
                            annotation_convention = "doxygen_triple_slash",
                        },
                    },
                },
            })
        end,
    },
}
