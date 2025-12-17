return {
  {
    "LazyVim/LazyVim",
    init = function()
      if os.getenv("DOTFILES_ID") == "aikido" and string.find(vim.fn.getcwd(), "Documents/git") then
        vim.g.autoformat = false

        local DOTFILES_LOCATION = os.getenv("DOTFILES_LOCATION")

        require("conform").setup({
          formatters = {
            php_cs_fixer = {
              command = "php-cs-fixer",
              args = {
                "fix",
                "--config=" .. DOTFILES_LOCATION .. "/cos/aikido/aikido-php-fixer-config.php",
                "--using-cache=no",
                "$FILENAME",
              },
              stdin = false,
              cwd = require("conform.util").root_file({ "composer.json" }),
            },
          },
        })

        require("lint").linters.phpcs.args = {
          "--standard=" .. vim.fn.expand(DOTFILES_LOCATION .. "/cos/aikido/aikido-phpcs.xml"),
          "--report=json",
          "-q",
          "-", -- Read from stdin
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "php",
          callback = function()
            vim.bo.expandtab = false
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end,
        })
      end
    end,
  },
}
