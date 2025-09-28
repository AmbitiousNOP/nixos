{config, pkgs, lib, ...}:

let
  customOhMyZshTheme = ''
# Identify if in Nix Dev Shell 
autoload -U colors && colors

if [[ -n "$IN_NIX_SHELL" ]]; then
  PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} [NIX DEV  ]:%{''$fg_bold[red]%}%1{➜%} ) %{''$fg[cyan]%}%c%{''$reset_color%}"
  PROMPT+=' ''$(git_prompt_info)'

  ZSH_THEME_GIT_PROMPT_PREFIX="%{''$fg_bold[blue]%}git:(%{''$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{''$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{''$fg[blue]%}) %{''$fg[yellow]%}%1{✗%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{''$fg[blue]%})"
else

  PROMPT="%(?:%{''$fg_bold[green]%}%1{➜%}  :%{''$fg_bold[red]%}%1{➜%} ) %{''$fg[cyan]%}%c%{''$reset_color%}"
  PROMPT+=' ''$(git_prompt_info)'

  ZSH_THEME_GIT_PROMPT_PREFIX="%{''$fg_bold[blue]%}git:(%{''$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{''$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{''$fg[blue]%}) %{''$fg[yellow]%}%1{✗%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{''$fg[blue]%})"
fi
  '';

  prependZshCustom = ''
    export ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh/custom"
  '';
in
{
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = customOhMyZshTheme;
  #home.file.".zshrc".text = ''
  #  ${prependZshCustom}
  #'';
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      #autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      #setOptions = [ "PROMPT_SUBST" ];
      envExtra = ''
${prependZshCustom}
      '';
    
      oh-my-zsh = {
	enable = true;
	plugins = ["git"];
	theme = "custom";
      };
    };

    ghostty = {
      enable = true;
      settings = {
        theme = "Rose Pine Moon";
	background-opacity = 0.85;
	background = "#000000";
	background-blur = false;
	confirm-close-surface = false; 
	#shell-integration-features = "no-cursor";
	#gtk-titlebar = false;
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
set -g default-terminal "tmux-256color"
set -s escape-time 0
set -g history-limit 50000
set -g display-time 4000
set -g status-style 'bg=#333333 fg=#5eacd3'
set -g status-interval 5 
set -g base-index 1
set-window-option -g mode-keys vi
setw -g aggressive-resize on
      '';
    }; 
  };
}

