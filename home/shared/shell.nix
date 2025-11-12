{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "rust" "npm" "node" "python" ];
    };

    shellAliases = {
      ls = "eza --group-directories-first --icons --classify";
      ll = "eza -l --group-directories-first --icons --classify --git";
      la = "eza -la --group-directories-first --icons --classify --git";
      lt = "eza -l --tree --level=2 --group-directories-first --icons";
      
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcd = "docker-compose down";
      dcl = "docker-compose logs -f";
      dps = "docker ps";
      
      projects = "cd ~/Projects";
      dots = "cd ~/nix";
    };

    initExtra = lib.mkAfter ''
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      setopt MENU_COMPLETE
      setopt AUTO_LIST
      setopt AUTO_CD
      setopt AUTO_PUSHD
    '';
  };

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
      git_branch.symbol = " ";
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}
