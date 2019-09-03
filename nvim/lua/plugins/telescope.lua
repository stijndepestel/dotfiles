local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local live_mutligrep = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }

			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.iter({
				args,
				{
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--no-ignore-vcs",
				},
			}):flatten():totable()
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		 {
		 	"nvim-telescope/telescope-fzf-native.nvim",
		 	build = "make",
		 	config = function()
		 		require("telescope").load_extension("fzf")
			end,
	 },
   { 
      "nvim-telescope/telescope-live-grep-args.nvim" ,
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
   },
	},
	opts = {
		-- defaults = require("telescope.themes").get_ivy(),
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
			},
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
		},
 		{
 			"<leader>fm",
 			live_mutligrep,
 	 	},
    {
      "<leader>fd",
      function()
        require("telescope.builtin").diagnostics()
      end
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").lsp_references()
      end
    },
    {
      "<leader>fy",
      function()
        require("telescope.builtin").oldfiles()
      end
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").buffers()
      end
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").spell_suggest()
      end
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end
    },
		-- {
		-- 	"<leader>fs",
		-- 	function()
		-- 		require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
		-- 	end,
		--},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
		},
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches()
      end,
    },
    {
      "<leader>gf",
      function()
        require("telescope.builtin").git_files()
      end,
    },
--  		{
--  			"<leader>fg",
--  			live_mutligrep,
--  	 	},
	},
  config = function ()
    local telescope = require("telescope") 
    telescope.load_extension("live_grep_args")
  end
}


-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
