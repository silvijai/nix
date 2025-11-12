{ config, pkgs, lib, ... }:
{
  # Advanced Zsh configuration
  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ 
        "git" 
        "docker" 
        "rust"
        "npm"
        "node"
        "python"
      ];
    };

    # Additional aliases
    shellAliases = {
      # Enhanced git
      gst = "git status";
      gco = "git checkout";
      gcb = "git checkout -b";
      gaa = "git add --all";
      gcm = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      
      # Docker shortcuts
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcd = "docker-compose down";
      dcl = "docker-compose logs -f";
      dps = "docker ps";
      
      # Project navigation (customize these)
      projects = "cd ~/Projects";
      dots = "cd ~/dotfiles";
    };

    # Additional zsh configuration
    initExtra = ''
      # Better history
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      
      # Better completion
      setopt MENU_COMPLETE
      setopt AUTO_LIST
      
      # Directory navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
    '';
  };

  # Starship prompt (works on both systems)
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      git_branch = {
        symbol = " ";
      };
      
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}

