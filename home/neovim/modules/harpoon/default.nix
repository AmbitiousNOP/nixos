{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      harpoon2
    ];
    extraLuaConfig = lib.mkAfter ''
      local harpoon = require('harpoon')
      harpoon:setup({})

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
          end

          require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                  results = file_paths,
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
          }):find()
      end

      vim.keymap.set("n", "<leader>hm", function() toggle_telescope(harpoon:list()) end,
          { desc = "Open [h]arpoon [m]enu" })
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, {desc = "[a]dd to harpoon"})
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, {desc = "Select first harpoon"})
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, {desc = "select second harpoon"})
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, {desc = "select third harpoon"})
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, {desc = "select fourth harpoon"})

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, {desc = "Stored [H]arpoon [P]revious"})
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, {desc = "Stored [H]arpoon [N]ext"})
    '';

  };
}
