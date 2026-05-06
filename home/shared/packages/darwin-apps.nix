{
  pkgs,
  lib,
  ...
}: {
  # macOS Homebrew casks (not used in this file, but kept for reference)
  macosPreferCask = [
    # Window Management
    "raycast"
    "loop"

    # System Utilities
    "karabiner-elements"
    "aldente"
    "the-unarchiver"
    "openmtp"
    "macs-fan-control"
    "hiddenbar"
    "monitorcontrol"
    "mos@beta"
    "logi-options+"

    # Browsers
    "zen"
    "min"
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
    "librepcb"

    # Creative Suite
    "affinity"
    "blender"
    "krita"
    "darktable"
    "freecad"
    "autodesk-fusion"
    "gimp"
    "sage"
    "jupyterlab-app"
    "microsoft-word"
    "spacedrive"

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
    "thunderbird"
    "proton-mail-bridge"
    "macfuse"

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
    "roblox"
    "mythic"
    "prismlauncher"

    # AI
    "ollama-app"

    # Entertainment
    "spotify"
    "audacity"
    "sioyek"
    "libreoffice"
    "libreoffice-language-pack"

    "docker-desktop"
  ];
}
