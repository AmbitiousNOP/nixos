vim.opt.shiftwidth = 2
vim.wo.number = true
vim.wo.relativenumber = true

-- Load each plugin's config manually
require("plugins.telescope")
require("plugins.treesitter")
