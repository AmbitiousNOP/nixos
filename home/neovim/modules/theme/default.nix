{pkgs, config, lib, ...}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      vim-moonfly-colors
    ];

    extraLuaConfig = lib.mkAfter ''
vim.cmd.colorscheme('moonfly')
    '';
  }; 
}
