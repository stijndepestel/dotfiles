return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tsserver = vim.tbl_deep_extend("force", opts.servers.tsserver or {}, {
        root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git"),
      })
      opts.servers.yamlls = {
        settings = {
          yaml = {
            validate = true,
            format = { enable = true },
            hover = true,
            completion = true,
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
              -- k8s
              ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.8-standalone-strict/all.json"] = {
                "**/*.k8s.yaml",
              },
            },
          },
        },
      }
      opts.servers.jsonls = {
        settings = {
          json = {
            validate = { enable = true },
            schemas = require("schemastore").json.schemas(),
            format = { enable = true },
          },
        },
      }
    end,
  },
}
