{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];

    extraLuaConfig = lib.mkAfter ''
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then 
      	return true
            end
          end,
        },
        indent = {enable = true},
      })

    '';
  };

}
