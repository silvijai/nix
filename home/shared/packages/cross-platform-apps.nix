{ pkgs, lib, ... }:
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

  linuxFlatpak = [
    "io.github.zen_browser.zen"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
  ];

  # Simple bash script - no complex string interpolation
  flatpakInstallScript = pkgs.writeShellScriptBin "flatpak-install" ''
    #!/usr/bin/env bash
    
    echo "Installing Flatpak applications..."
    
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    flatpak install -y flathub io.github.zen_browser.zen
    flatpak install -y flathub com.discordapp.Discord
    flatpak install -y flathub com.slack.Slack
    flatpak install -y flathub com.spotify.Client
    flatpak install -y flathub md.obsidian.Obsidian
    
    echo "Done!"
  '';
}
