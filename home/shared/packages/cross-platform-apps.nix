{ pkgs, lib, ... }:
{
  # Apps that work identically on both macOS and Linux via Nix
  both = with pkgs; [
    # Browsers (Nix versions work on both)
    
    
    # Development
    vscodium
    git
    kitty
    
    # Creative/Media
    blender
    krita
    gimp
    inkscape
    audacity
    musescore
    obs-studio
    vlc
    
    # Communication
    vesktop
    
    # Productivity
    obsidian
    anki
    libreoffice
    
    # Media utilities
    makemkv  # DVD ripper
    handbrake  # Video converter
    
    # Utilities
    cryptomator  # Encrypted cloud storage
  ];

  # macOS: Prefer Homebrew casks (better integration)
  macosPreferCask = [
    # These work better as casks on macOS
    "raycast"
    "alt-tab"
    "amethyst"  # Tiling WM for macOS
    "karabiner-elements"
    "aldente"
    
    # Affinity suite (macOS optimized)
    "affinity-designer"
    "affinity-publisher"
    "affinity-photo"
    "affinity"
    
    # Music production (macOS optimized)
    "ableton-live-standard"
    "supercollider"
    
    # Gaming
    "steam"
    "heroic"
    "whisky"  # Windows games on macOS
    
    # Proton apps (best via casks)
    "protonvpn"
    "proton-drive"
    "proton-pass"
    "proton-mail"
    
    # macOS-specific
    "onyx"  # System maintenance
    "utm"   # Virtual machines for macOS
    "openmtp"  # Android file transfer
  ];

  # Linux alternatives/equivalents
  linuxAlternatives = with pkgs; [
    # Window management (built into desktop setup)
    # rofi or wofi for app launcher
    
    # Gaming
    steam
    heroic  # Epic/GOG launcher
    lutris  # Game launcher
    wine
    winetricks
    
    # Proton alternatives
    protonvpn-cli
    
    # System utilities
    gparted  # Disk management
    gnome-disk-utility
    
    # Android
    android-file-transfer
    
    # Additional Linux-specific tools
    flameshot  # Screenshots
    peek  # Screen recording
  ];
}

