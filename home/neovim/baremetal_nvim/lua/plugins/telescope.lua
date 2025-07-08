local telescope = require("telescope")

telescope.setup({
  pickers = {
    find_files = {
      theme = "dropdown",
    },
  },
  extensions = {
    fzf = {},
  },
})

pcall(telescope.load_extension, "fzf")

-- Keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>fh", builtin.help_tags)
vim.keymap.set("n", "<space>fd", builtin.find_files)
vim.keymap.set("n", "<space>en", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end)
