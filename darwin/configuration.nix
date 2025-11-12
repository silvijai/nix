{ config, pkgs, inputs, lib, username, ... }: {
  # System user for user-specific options
  system.primaryUser = username;

  # Disable nix-darwin's Nix management (using Determinate Nix instead)
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages (available to all users)
  environment.systemPackages = with pkgs; [
    dockutil
  ];

  # Homebrew (applies to primaryUser)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    
    brews = [ ];
    
    # Import from cross-platform-apps.nix
    casks = (import ./home/shared/packages/cross-platform-apps.nix { inherit pkgs lib; }).macosPreferCask;
    
    masApps = {
      "Amphetamine" = 937984704;
      "Week Number" = 6502579523;
      "Hidden Bar" = 1452453066;
      "Pure Paste" = 1611378436;
      "Displaperture" = 1543920362;
      "Command X" = 6448461551;
      "DaVinci Resolve" = 571213070;
    };
  };
 
  # System defaults (apply to primaryUser)
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    loginwindow.GuestEnabled = false;
    screencapture.location = "~/Pictures/Screenshots";
    spaces.spans-displays = false;
  };

  # Fonts (individual Nerd Fonts packages - new syntax)
  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Enable Zsh as default shell
  programs.zsh.enable = true;

  # Touch ID for sudo (new option path)
  security.pam.services.sudo_local.touchIdAuth = true;

  # State version
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Simple: Create aliases in ~/Applications for Nix apps
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      
      # Search in both system and home manager packages
      for app_dir in ${env}/Applications /etc/profiles/per-user/${username}/home-path/Applications; do
        if [ -d "$app_dir" ]; then
          find "$app_dir" -maxdepth 1 \( -type l -o -type d -name "*.app" \) |
          while read -r src; do
            if [ -e "$src" ]; then
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            fi
          done
        fi
      done
    '';
}

