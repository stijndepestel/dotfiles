local lsp_servers = {
	"ts_ls",
	"clangd",
	"cssls",
	"lua_ls",
	"rust_analyzer",
	"angularls",
	"eslint",
	"svelte",
	"html",
	"gopls",
	"pyright",
	"ruff",
	"ansiblels",
}

return {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			opts = {
				ui = {
					border = "rounded",
				},
			},
		},
		{ "williamboman/mason-lspconfig.nvim" },

		-- Autocompletion and snippets
		{
			"saghen/blink.cmp",
			dependencies = "rafamadriz/friendly-snippets",
			version = "v0.*",
			opts = {
				keymap = { preset = "default" },
				completion = {
					menu = {
						draw = {
							treesitter = { "LSP" },
						},
					},
					documentation = {
						auto_show = true,
						window = {
							border = "rounded",
						},
					},
				},

				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "mono",
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},

				signature = { enabled = true },
			},
			opts_extend = { "sources.default" },
		},
	},
	config = function()
		local lsp = require("lsp-zero")
		local lsp_config = require("lspconfig")
		lsp.extend_lspconfig()

		lsp.on_attach(function(_, bufnr)
			lsp.default_keymaps({ buffer = bufnr })

			local opts = { buffer = bufnr, remap = false }

			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>vws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, opts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_next()
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_prev()
			end, opts)
			vim.keymap.set("n", "<leader>vca", function()
				vim.lsp.buf.code_action()
			end, opts)
			vim.keymap.set("n", "<leader>vrr", function()
				vim.lsp.buf.references()
			end, opts)
			vim.keymap.set("n", "<leader>vrn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end)

		-- Add the border on hover and on signature help popup window
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		}

		-- Add border to the diagnostic popup window

        for _, server in ipairs(lsp_servers) do
            lsp_config[server].setup({ handlers = handlers });
        end

		lsp_config.lua_ls.setup({
            handlers = handlers,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		})

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = lsp_servers,
			handles = {
				lsp.default_setup,
				ts_ls = function()
					lsp_config.ts_ls.setup({
						settings = {
							completions = {
								completeFunctionCalls = true,
							},
						},
					})
				end,
				lua_ls = function()
					local lua_opts = lsp.nvim_lua_ls()
					lsp_config.lua_ls.setup(lua_opts)
				end,
				pyright = function()
					lsp_config.pyright.setup({
                        handlers = handlers,
						settings = {
							pyright = {
								disableOrganizeImports = true,
							},
							python = {
								analysis = {
									ignore = { "*" },
								},
							},
						},
					})
				end,
				ruff = function()
					lsp_config.ruff.setup({
						on_attach = function(client, _)
							if client.name == "ruff" then
								client.server_capabilities.hoverProvider = false
							end
						end,
					})
				end,
			},
		})

		lsp.setup_servers(lsp_servers)

		local lspconfig_defaults = lsp_config.util.default_config
		lspconfig_defaults.capabilities =
			vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("blink.cmp").get_lsp_capabilities())

		lsp.set_sign_icons({
			error = "E",
			warn = "W",
			hint = "H",
			info = "I",
		})

		lsp.setup()

		vim.diagnostic.config({
			virtual_text = true,
			float = { border = "rounded" },
		})
	end,
}
