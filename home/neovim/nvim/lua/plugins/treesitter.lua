return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		local install = require("nvim-treesitter.install")
		install.parser_install_dir = vim.fn.stdpath("data") .. "/parsers"
		install.prefer_git = false

		require("nvim-treesitter.configs").setup({
			ensure_installed = {},
			auto_install = false,
			highlight = {
				enable = true,
				disalbe = function(lang, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.loop.fs.stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlight = false,
			},
		})
	end,
}
