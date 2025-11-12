{ pkgs, lib, ... }:
let
  flatpakApps = [
    "io.github.zen_browser.zen"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
  ];
  
  # Create install script with proper escaping
  installCommands = lib.concatMapStringsSep "\n" (app: 
    "  echo 'Installing ${app}...'\n" +
    "  flatpak install -y flathub '${app}' 2>&1 || echo 'Failed: ${app}'"
  ) flatpakApps;
in
{
  both = with pkgs; [
    vscodium
    git
    kitty
    firefox
    chromium
    blender
    krita
    gimp
    inkscape
    audacity
    musescore
    obs-studio
    vlc
    vesktop
    obsidian
    anki
    libreoffice
    makemkv
    handbrake
    cryptomator
  ];

  macosPreferCask = [
    "raycast"
    "alt-tab"
    "amethyst"
    "karabiner-elements"
    "aldente"
    "affinity-designer"
    "affinity-publisher"
    "affinity-photo"
    "ableton-live-standard"
    "supercollider"
    "steam"
    "heroic"
    "whisky"
    "protonvpn"
    "proton-drive"
    "proton-pass"
    "proton-mail"
    "onyx"
    "utm"
    "openmtp"
  ];

  linuxNix = with pkgs; [
    steam
    heroic
    lutris
    wine
    winetricks
    protonvpn-gui
    gparted
    gnome-disk-utility
    android-file-transfer
    wl-clipboard
    wev
    wlr-randr
    kanshi
    grim
    slurp
    swappy
    wf-recorder
  ];

  linuxFlatpak = flatpakApps;

  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "📦 Installing Flatpak applications..."
    
    # Add flathub
    if ! flatpak remote-list | grep -q flathub; then
      echo "Adding Flathub repository..."
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Install apps
${installCommands}
    
    echo "✅ Flatpak installation complete!"
  '';
}
