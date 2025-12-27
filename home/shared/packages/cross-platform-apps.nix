{ pkgs, lib, ... }:
let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in
{
  # Apps that work on ALL platforms (macOS + Linux, x86 + ARM)
  both = with pkgs; [
    git
    inkscape
    audacity
    sioyek
  ];

  # Linux-only packages (architecture-aware)
  linuxNix = with pkgs; [
    # Browsers (all have ARM support)
    firefox
    chromium

    # Communication
    vesktop
    
    # Productivity
    obsidian
    anki
    libreoffice
    
    # Creative (ARM-native)
    blender
    krita
    obs-studio
    musescore
    vlc
    gimp
    
    # Media utilities
    handbrake
    
    # VPN
    protonvpn-gui
    
    # System utilities
    gparted
    gnome-disk-utility
    android-file-transfer
    
    # Wayland tools
    wl-clipboard
    wev
    wlr-randr
    kanshi
    
    # Screenshots
    grim
    slurp
    swappy
    wf-recorder

    # compatability layers
    box64
    qemu
  ] 
  # x86-only packages (excluded on ARM)
  ++ lib.optionals isX86_64 [
    steam
    heroic
    lutris
    wine
    winetricks
    makemkv
    cryptomator
    github-desktop
  ]
  # ARM-specific alternatives
  ++ lib.optionals isAarch64 [
    # Native ARM gaming (if needed)
    # Add ARM-native game launchers here
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

    "com.valvesoftware.Steam"
    "com.heroicgameslauncher.hgl"

    "org.cryptomator.Cryptomator"
    "io.github.shiftey.Desktop"
  ];

  # Flatpak install script
  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" ''
    #!/usr/bin/env bash
    set -e
    
    echo "Installing Flatpak applications..."
    
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

    flatpak install -y flathub com.valvesoftware.Steam || true
    flatpak install -y flathub com.heroicgameslauncher.hgl || true

    flatpak install -y flathub org.cryptomator.Cryptomator || true
    flatpak install -y flathub io.github.shiftey.Desktop || true
    
    echo "Done!"
  '';

  # macOS Homebrew casks (not used in this file, but kept for reference)
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
    "hiddenbar" 

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
    "vscodium"
    
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
    "thunderbird"
    "proton-mail-bridge"
    
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
    "ollama"
    
    # Entertainment
    "spotify"
  ];
}
