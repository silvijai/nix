{ config, pkgs, inputs, ... }: {
  # User info
  home.username = "viliusi";  # Replace with your username
  home.homeDirectory = "/Users/viliusi";
  home.stateVersion = "24.05";

  # Let Home Manager install itself
  programs.home-manager.enable = true;

  # User packages (supplements system packages)
  home.packages = with pkgs; [
    # File management with eza
    eza
    
    # Development tools specific to you
    nodePackages.typescript
    nodePackages.eslint
    rust-analyzer
    
    # Terminal utilities
    htop
    ripgrep
    fd
    bat
    
    # Japanese language learning tools (based on your profile)
    # anki-bin  # Uncomment if available
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Shell aliases (your eza defaults)
    shellAliases = {
      ls = "eza --group-directories-first --icons --classify";
      ll = "eza -l --group-directories-first --icons --classify --git";
      la = "eza -la --group-directories-first --icons --classify --git";
      lt = "eza -l --tree --level=2 --group-directories-first --icons";
      
      # Development aliases
      nrs = "darwin-rebuild switch --flake ~/nix";
      nrb = "darwin-rebuild build --flake ~/nix";
    };

    # Custom prompt or use starship
    initExtra = ''
      # Add any custom zsh configuration here
      export EDITOR=vim
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";  # Replace
    userEmail = "your.email@example.com";  # Replace
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      pull.rebase = false;
    };
  };

  # Neovim with basic config (building on your nixvim interest)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      " Basic settings
      set number
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      
      " JavaScript/TypeScript - 2 spaces (as per your earlier query)
      autocmd FileType javascript,typescript,json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    '';
  };

  # Direnv for project environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}

