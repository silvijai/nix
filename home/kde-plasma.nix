{ config, pkgs, lib, ... }:
{
  programs.plasma.enable = true;  # Integrates with KDE

  # Declarative KDE Plasma settings
  programs.plasma.configFile = {
    # macOS-like dock (Latte Dock or Plasma Panel)
    "plasmarc" = {
      "Wallpapers" = {
        "wallpaperplugin" = "org.kde.image";
        "wallpaper" = "~/Pictures/wallpaper.png";
      };
    };

    # Keyboard shortcuts (Command key)
    "kwinrc" = {
      "ModifierOnlyShortcuts" = {
        "Meta" = "KWin.Meta";
      };
    };

    # Power management (battery)
    "powerdevilrc" = {
      "Battery" = {
        "OnAc" = "performance";
        "OnBattery" = "powersave";
      };
    };
  };

  # KDE respects Nix packages + Flatpaks
  xdg.desktopEntries = {
    kitty = {
      name = "Kitty Terminal";
      exec = "${pkgs.kitty}/bin/kitty";
      terminal = false;
      categories = [ "TerminalEmulator" "Utility" ];
    };
  };
}

