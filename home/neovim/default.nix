{pkgs, config, ...}:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-solarized-lua
      nvim-web-devicons
      git-blame-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      lualine-nvim
      trouble-nvim
      nvim-autopairs
      telescope-nvim
      (which-key-nvim.overrideAttrs (final: prev: {
        src = pkgs.fetchgit{
	  url = "https://github.com/folke/which-key.nvim";
	  rev = "2e36a3f66603723ceb9dbf2942dfad171f443133";
	  sha256 = "sha256-6QaJkXZtfWZaUO74SMnmn6eTTmsTfTH7FfCEjw1DnzA";
        };
	}))
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-zsh
      cmp-nvim-lua
      nvim-lspconfig
      cmp-nvim-lsp
      none-ls-nvim
    ];
  };

  home.packages = with pkgs; [
    ripgrep
    lua-language-server
    stylua
    nixd
    fd
    fzf
    cmake
    gnumake
  ];

  home.file.".config/nvim" = {
    source = ./nvimFancy;
    recursive = true;
  };

  #home.file.".config/nvim" = {
  #    source = ./baremetal_nvim;
  #    recursive = true;
  #  };
}
