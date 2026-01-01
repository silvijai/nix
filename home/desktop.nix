{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./common.nix
    ./nix-common.nix
    ./shared/development.nix
    ./shared/workstation.nix  # Includes Kitty and Flatpak
  ];

  home.username = "silvija";
  home.homeDirectory = "/home/silvija";

  # Universal update alias (works on any NixOS system)
  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch --flake ~/nix#$(hostname)";
  };

  # FULL macOS-STYLE SWAY CONFIG
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];

    config = {
      # macOS Command key (Mod4 = Super/Command)
      modifier = "Mod4";

      # Monitors (auto-detect)
      output = { 
	"*" = { 
	  bg = "~/Pictures/wallpaper.png fill"; 
	  mode = "preferred,auto,1"; 
	}; 
      };

      # Input (Trackpad + macOS keyboard)
      input = {
        "*" = {
          xkb_layout = "dk";
          xkb_options = "ctrl:menu,compose:ralt";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";  # macOS style
          middle_emulation = "enabled";
        };
      };

      # macOS-like appearance
      gaps = { inner = 8; outer = 4; };
      # border = { normal = 2; focus = 2; };

      colors = {
        focused = { 
          border = "#4c7899"; 
          background = "#285577"; 
          text = "#ffffff"; 
          indicator = "#2e99f1"; 
          childBorder = "#285577"; 
        };
        focusedInactive = { 
          border = "#333333"; 
          background = "#5f676a"; 
          text = "#ffffff"; 
          indicator = "#484e50"; 
          childBorder = "#5f676a"; 
        };
        unfocused = { 
          border = "#333333"; 
          background = "#5f676a"; 
          text = "#ffffff"; 
          indicator = "#484e50"; 
          childBorder = "#5f676a"; 
        };
      };

      # CORRECT - Simple string syntax 
      keybindings = {
        "Mod4+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "Mod4+Shift+q" = "kill";
        "Mod4+Q" = "exec thunar";
        "Mod4+D" = "exec wofi --show drun";
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+e" = "exec swaymsg exit";

        # Workspaces
        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";

        # Navigation (Vim-style)
        "Mod4+h" = "focus left";
        "Mod4+j" = "focus down";
        "Mod4+k" = "focus up";
        "Mod4+l" = "focus right";

        "Mod4+Shift+h" = "move left";
        "Mod4+Shift+j" = "move down";
        "Mod4+Shift+k" = "move up";
        "Mod4+Shift+l" = "move right";

        # macOS-like
        "Mod4+f" = "fullscreen toggle";
        "Mod4+s" = "layout stacking toggle_split";
      };


      startup = [{ command = "systemctl --user restart waybar"; }];
    };
  };

  # Perfect Sway + Flatpak setup
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;  # Opens flatpaks correctly
  };


  # Essential macOS-like apps (MERGES with workstation.nix)
  home.packages = with pkgs; [
    # Terminal (already in workstation.nix, but explicit for clarity)
    kitty
    
    # Cmd+D launcher
    wofi
    
    # Screenshot tools
    grim slurp wl-clipboard swappy    
    
    # Audio mixer
    pavucontrol
    
    # Brightness & Network
    brightnessctl networkmanagerapplet
    
    # Bluetooth
    bluez
  ];

  # Waybar (macOS menu bar style)
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * { font-family: "JetBrains Mono Nerd Font"; }
      window#waybar { 
        background: rgba(40, 85, 119, 0.9); 
        border-bottom: 2px solid #4c7899; 
      }
    '';
    settings = [{
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
      clock = { format-alt = "{:%Y-%m-%d}"; };
    }];
  };

  # Autostart (safe with your imports)
  programs.zsh.profileExtra = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
}

