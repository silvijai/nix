{ config, pkgs, lib, ... }:
{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vilius Ivanovas";
        email = "ivanovasvilius@example.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Use lib.mkBefore for init code
    initContent = lib.mkBefore ''
      export EDITOR=nvim
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    extraConfig = ''
      set -g status-position top
      set -g base-index 1
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    curl
    wget
    jq
    eza
    glow
  ];
}
