{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Git - same everywhere
  programs.git = {
    enable = true;
    userName = "Vilius Ivanovas";
    userEmail = "ivanovasvilius@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
    };
  };

  # Basic Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      export EDITOR=nvim
    '';
  };

  # Tmux
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    extraConfig = ''
      set -g status-position top
      set -g base-index 1
    '';
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Essential CLI tools
  home.packages = with pkgs; [
    curl
    wget
    jq
    eza
    glow
  ];
}

