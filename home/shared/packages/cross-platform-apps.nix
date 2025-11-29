{ pkgs, lib, ... }:
{
  # Apps available via Nix on BOTH macOS (aarch64-darwin) AND Linux
  # ONLY packages verified to work on Apple Silicon
  both = with pkgs; [
    # Development tools
    git
    
    # Creative/Media - VERIFIED aarch64-darwin support
    inkscape
    audacity

    ollama
  ];

  # macOS: Prefer Homebrew casks (better integration)
  macosPreferCask = [
    # Window Management
    "raycast"
    "alt-tab"
    "amethyst"
    "loop"
    
    # System Utilities
    "karabiner-elements"
    "aldente"
    "onyx"
    "the-unarchiver"
    "openmtp"
    "fuse-t"
    "macs-fan-control"
    
    # Browsers
    "zen"
    "min"
    "qutebrowser"
    "sigmaos"
    "librewolf"
    "orion"
    
    # Communication
    "beeper"
    "vesktop"
    
    # Development
    "github"
    "utm"
    "kitty"
    
    # Creative Suite
    "affinity-designer"
    "affinity-publisher"
    "affinity-photo"
    "affinity"
    "blender"
    "krita"
    "darktable"
    "freecad"
    "autodesk-fusion"
    "gimp"
    
    # Music Production
    "ableton-live-standard"
    "lmms"
    "deelay"
    "supercollider"
    "surge-xt"
    
    # Media
    "iina"
    "obs"
    "xld"
    "makemkv"
    "musicbrainz-picard"
    
    # Productivity
    "obsidian"
    "anki"
    "deepl"
    "ticktick"
    "browserosaurus"
    
    # Security/Privacy
    "protonvpn"
    "proton-drive"
    "proton-pass"
    "proton-mail"
    "cryptomator"
    
    # Gaming
    "steam"
    "whisky"
    "heroic"
    
    # AI
    "anythingllm"
    
    # Entertainment
    "spotify"
  ];

  # Linux: Additional Nix packages
  linuxNix = with pkgs; [
    # Browsers
    firefox
    chromium
    
    # Creative - Linux full support
    blender
    krita
    obs-studio
    musescore
    vlc
    gimp
    
    # Communication
    vesktop
    
    # Productivity
    obsidian
    anki
    libreoffice
    
    # Media utilities
    makemkv
    handbrake
    
    # Gaming
    steam
    heroic
    lutris
    wine
    winetricks
    
    # VPN
    protonvpn-gui
    
    # System utilities
    gparted
    gnome-disk-utility
    android-file-transfer
    cryptomator
    
    # Wayland tools
    wl-clipboard
    wev
    wlr-randr
    kanshi
    
    # Screenshots/recording
    grim
    slurp
    swappy
    wf-recorder
  ];

  # Flatpak apps (Linux only)
  linuxFlatpak = [
    "io.github.zen_browser.zen"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
    "org.blender.Blender"
    "com.obsproject.Studio"
    "org.kde.krita"
  ];

  # Flatpak installation script
  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" ''
    #!/usr/bin/env bash
    set -e
    
    echo "📦 Installing Flatpak applications..."
    
    if ! flatpak remote-list | grep -q flathub; then
      echo "Adding Flathub repository..."
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    flatpak install -y flathub io.github.zen_browser.zen || true
    flatpak install -y flathub com.discordapp.Discord || true
    flatpak install -y flathub com.slack.Slack || true
    flatpak install -y flathub com.spotify.Client || true
    flatpak install -y flathub md.obsidian.Obsidian || true
    flatpak install -y flathub org.blender.Blender || true
    flatpak install -y flathub com.obsproject.Studio || true
    flatpak install -y flathub org.kde.krita || true
    
    echo "✅ Done!"
  '';
}
