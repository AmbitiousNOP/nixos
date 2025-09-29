{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
    ];

    extraLuaConfig = lib.mkAfter ''
      require('lualine').setup({
        options = { theme = 'auto' },
      })
    '';
  };

}
