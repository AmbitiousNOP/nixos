{pkgs, ...}:
{

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      #autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    
      oh-my-zsh = {
	enable = true;
	plugins = ["git"];
	theme = "robbyrussell";
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

