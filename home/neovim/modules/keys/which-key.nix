{ pkgs
, config
, lib
, ...
}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      which-key-nvim
    ];
    extraLuaConfig = lib.mkAfter ''
local wk = require("which-key")
wk.opts = {
  delay = 0,
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {},
    spec = {
      {'<leader>s', group = '[S]earch'},
      {'<leader>t', group = '[T]oggle'},
      {'<leader>h', group = 'Git [H]unk', mode = {'n','v'}},
    },
  },
}
    '';
  };

}
