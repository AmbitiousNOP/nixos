return {
	-- change some telescope options and a keymap to browse plugin files
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				-- inorder for this to work. You need to manually build with make.
				-- CMD: cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim/
				-- CMD: make
				-- which would then spit out the .so file that nvim is crying about.
				"nvim-telescope/telescope-fzf-native.nvim",
			},
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = "dropdown",
					},
				},
				extension = {
					fzf = {},
				},
			})

			pcall(require("telescope").load_extension("fzf"))

			vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
			vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
			vim.keymap.set("n", "<space>en", function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end)
		end,
	},
}
