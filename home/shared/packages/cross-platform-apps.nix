{ pkgs, lib, ... }:
let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in
{
  # Universal apps (macOS + Linux)
  both = with pkgs; [
    git
    ripgrep
    fd
    eza
    bat
    zoxide
    fzf
    tldr
    neovim
    inkscape
    audacity
    sioyek
  ];

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
    
    # Creative (ARM optimized)
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
    xfce.thunar
    
    # Wayland essentials
    wl-clipboard wev wlr-randr kanshi grim slurp swappy wf-recorder 
    
    # Gaming/VM
    box64 
    qemu
  ] ++ lib.optionals isX86_64 [
    steam heroic lutris wine winetricks makemkv
  ];

  # DECLARATIVE FLATPAK (Replaces script)
  flatpaks = with lib; [
    # Browsers
    "io.github.zen_browser.zen"
    "org.librewolf.community"
    
    # Communication (KDE Discover optimized)
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
    "ollama-app"
    
    # Entertainment
    "spotify"
  ];
}
