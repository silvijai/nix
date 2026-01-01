{ pkgs, lib, ... }:
{
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
    "the-unarchiver"
    "openmtp"
    "macs-fan-control"
    "hiddenbar"
    "mos"

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