{ pkgs, lib, ... }:
{
  # Apps available via Nix on both macOS and Linux
  both = with pkgs; [
    # Development
    vscodium
    git
    
    # Terminal
    kitty
    
    # Browsers
    firefox
    chromium
    
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
    vesktop  # Discord alternative
    
    # Productivity
    obsidian
    anki
    libreoffice
    
    # Media utilities
    makemkv
    handbrake
    
    # Utilities
    cryptomator
  ];

  # macOS: Prefer Homebrew casks (better integration)
  macosPreferCask = [
    # System utilities
    "raycast"
    "alt-tab"
    "amethyst"
    "karabiner-elements"
    "aldente"
    
    # Creative suite
    "affinity-designer"
    "affinity-publisher"
    "affinity-photo"
    
    # Music production
    "ableton-live-standard"
    "supercollider"
    
    # Gaming
    "steam"
    "heroic"
    "whisky"
    
    # Proton suite
    "protonvpn"
    "proton-drive"
    "proton-pass"
    "proton-mail"
    
    # macOS-specific
    "onyx"
    "utm"
    "openmtp"

    "raycast"
    "kitty"
    "deepl"
    "obsidian"
    "freecad"
    "autodesk-fusion"
    "protonvpn"
    "proton-drive"
    "proton-pass"
    "proton-mail"
    "github"
    "the-unarchiver"
    "zen"
    "min"
    "qutebrowser"
    "sigmaos"
    "amethyst"
    "loop"
    "affinity-designer"
    "affinity-publisher"
    "affinity-photo"
    "affinity"
    "blender"
    "ableton-live-standard"
    "lmms"
    "deelay"
    "darktable"
    "anki"
    "karabiner-elements"
    "krita"
    "makemkv"
    "onyx"
    "steam"
    "whisky"
    "surge-xt"
    "librewolf"
    "supercollider"
    "utm"
    "xld"
    "iina"
    "alt-tab"
    "obs"
    "musicbrainz-picard"
    "aldente"
    "openmtp"
    "heroic"
    "beeper"
    "orion"
    "fuse-t"
    "cryptomator"
    "ticktick"
    "anythingllm"
    "spotify"
  ];

  # Linux: Additional tools & alternatives
  linuxNix = with pkgs; [
    # Gaming
    steam
    heroic
    lutris
    wine
    winetricks
    
    # Proton alternatives
    protonvpn-cli
    
    # System utilities
    gparted
    gnome-disk-utility
    
    # Android
    android-file-transfer
    
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
    # Browsers
    "io.github.zen_browser.zen"
    
    # Communication
    "com.discordapp.Discord"
    "com.slack.Slack"
    
    # Creative (if not using Nix version)
    "org.blender.Blender"
    "org.gimp.GIMP"
    "org.inkscape.Inkscape"
    "org.audacityteam.Audacity"
    
    # Media
    "org.videolan.VLC"
    "com.spotify.Client"
    "io.mpv.Mpv"
    
    # Productivity
    "md.obsidian.Obsidian"
    "net.ankiweb.Anki"
    "org.libreoffice.LibreOffice"
    "com.github.xournalpp.xournalpp"
    
    # Development
    "com.visualstudio.code"  # If you prefer over vscodium
    
    # Gaming
    "com.valvesoftware.Steam"
    "com.heroicgameslauncher.hgl"
    
    # Utilities
    "org.cryptomator.Cryptomator"
  ];

  # Flatpak installation script
  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" ''
    #!/usr/bin/env bash
    echo "📦 Installing Flatpak applications..."
    
    # Add flathub if not already added
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Install each app
    ${lib.concatMapStringsSep "\n" (app: ''
      echo "Installing ${app}..."
      flatpak install -y flathub ${app} || echo "Failed to install ${app}"
    '') linuxFlatpak}
    
    echo "✅ Flatpak installation complete!"
  '';
}
