{ pkgs, lib, ... }:
let
  # Define flatpak apps list
  flatpakApps = [
    "io.github.zen_browser.zen"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
  ];
in
{
  # Apps available via Nix on both macOS and Linux
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

  # macOS: Prefer Homebrew casks
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

  # Linux: Additional Nix packages
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

  # Expose flatpak list
  linuxFlatpak = flatpakApps;

  # Flatpak installation script - Fixed string interpolation
  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" 
    (''
      #!/usr/bin/env bash
      echo "📦 Installing Flatpak applications..."
      
      # Add flathub if not already added
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      
      # Install each app
    '' + (lib.concatMapStringsSep "\n" (app: ''
      echo "Installing ${app}..."
      flatpak install -y flathub ${app} || echo "⚠️  Failed to install ${app}"
    '') flatpakApps) + ''
      
      echo "✅ Flatpak installation complete!"
    '');
}
