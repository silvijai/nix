{ pkgs, lib, ... }:
{
# Native Nix packages (Linux)
  linuxNix = with pkgs; [
    # Browsers
    firefox
    (chromium.override { commandLineArgs = "--enable-features=VaapiVideoDecoder"; })
    
    # Communication
    vesktop
    element-desktop
    
    # Productivity
    obsidian
    anki
    libreoffice-qt
    
    # Creative
    blender
    krita
    obs-studio
    musescore
    vlc
    gimp
    
    # Utilities
    handbrake
    gparted
    gnome-disk-utility
    thunar
    
    # Wayland essentials
    wl-clipboard wev wlr-randr kanshi grim slurp swappy wf-recorder 
    
    # Gaming/VM
    box64 
    qemu
  ];

  # DECLARATIVE FLATPAK (Replaces script)
  flatpaks = [
    # Browsers
    "io.github.zen_browser.zen"
    "org.librewolf.community"
    
    # Communication
    "com.discordapp.Discord"
    "com.slack.Slack"
    "org.telegram.desktop"
    
    # Media/Creative
    "com.spotify.Client"
    "com.obsproject.Studio"
    "org.blender.Blender"
    "org.kde.krita"
    
    # Gaming
    "com.valvesoftware.Steam"
    "com.heroicgameslauncher.hgl"
    
    # Productivity
    "md.obsidian.Obsidian"
    "org.cryptomator.Cryptomator"
    "io.github.shiftey.Desktop"
  ];
}