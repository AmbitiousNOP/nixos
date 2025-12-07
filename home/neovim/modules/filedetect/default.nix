{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      helm-ls-nvim
    ];
    extraLuaConfig = lib.mkAfter ''
      		local helmls = require('helm-ls').setup()
    '';

  };
}
