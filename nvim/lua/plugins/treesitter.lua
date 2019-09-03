return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
            ensure_installed = {
                "vimdoc",
                "javascript",
                "typescript",
                "c",
                "lua",
                "rust",
                "go",
                "hcl",
                "json",
                "yaml",
                "sql"
            },

            sync_install = false,
            auto_install = true,

            hightlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
    },
}
