{
  config,
  pkgs,
  inputs,
  lib,
  username,
  ...
}: let
  apps = import ../home/shared/packages/cross-platform-apps.nix {inherit pkgs lib;};
  darwinApps = import ../home/shared/packages/darwin-apps.nix {inherit pkgs lib;};
in {
  # Set primary user
  system.primaryUser = username;

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = ["mas"];

    casks = darwinApps.macosPreferCask;

    masApps = {
      "Amphetamine" = 937984704;
      "Week Number" = 6502579523;
      "Pure Paste" = 1611378436;
      "Displaperture" = 1543920362;
      "Command X" = 6448461551;
      "DaVinci Resolve" = 571213070;
    };
  };

  # System defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
      tilesize = 48;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      AppleShowAllFiles = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    loginwindow.GuestEnabled = false;
    screencapture.location = "~/Pictures/Screenshots";
    spaces.spans-displays = false;
  };

  # Fonts
  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    # pkgs.nerd-fonts.jetbrains-mono
  ];

  # Enable Zsh
  programs.zsh.enable = true;

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # State version
  system.stateVersion = 4;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.silvija = import ../home/darwin.nix;
  };
}
