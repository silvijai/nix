{ config, pkgs, inputs, username, ... }: {
  # Enable experimental features
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages (available to all users)
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    git
    curl
    wget
    
    # Development tools
    nodejs
    python3
    rustc
    cargo
    
    # Music production basics (GUIs need special handling on macOS)
    # NOTE: For Ableton Live, you'll need to use homebrew or direct install
  ];

  # Homebrew integration (for GUI apps not available in nixpkgs)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";  # Remove unlisted brews/casks
      autoUpdate = true;
      upgrade = true;
    };
    
    # CLI tools that work better via homebrew
    brews = [
      # Add any brew-specific tools here
    ];
    
    # GUI applications
    casks = [
      "visual-studio-code"  # VS Code
      "spotify"             # Music
      # "ableton-live-lite"  # Uncomment if you use Ableton
      # Add other GUI apps you need
    ];
    
    # Mac App Store apps
    masApps = {
      # "Xcode" = 497799835;  # Uncomment if needed
    };
  };

  # System defaults (macOS preferences)
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "bottom";
      tilesize = 48;
    };
    
    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";  # Column view
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    
    # Login window
    loginwindow.GuestEnabled = false;
    
    # Screenshots
    screencapture.location = "~/Pictures/Screenshots";
    
    # Mission Control
    spaces.spans-displays = false;
  };

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Shell configuration
  programs.zsh.enable = true;  # Default shell

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System state version
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";  # or "x86_64-darwin" for Intel
}

