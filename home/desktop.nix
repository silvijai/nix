{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./common.nix
    ./shared/development.nix
    ./shared/workstation.nix  # Includes Kitty and Flatpak
  ];

  home.username = "silvija";
  home.homeDirectory = "/home/silvija";

  # Override update alias
  programs.zsh.shellAliases = {
    update = lib.mkForce "sudo nixos-rebuild switch --flake /home/viliusi/nix#linux-laptop";
  };

  # Hyprland configuration (Wayland)
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;  # Enable systemd integration
    
    settings = {
      monitor = [ ",preferred,auto,1" ];
      
      exec-once = [
        "waybar"
        "dunst"
        "swww init"
        "flatpak-install"  # Auto-install flatpak apps on first boot
      ];

      input = {
        kb_layout = "dk";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ff) rgba(94e2d5ff) 45deg";
        "col.inactive_border" = "rgba(313244ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = "smoothOut, 0.36, 0, 0.66, -0.56";
        animation = [
          "windows, 1, 5, smoothOut, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "border, 1, 10, default"
          "fade, 1, 4, smoothOut"
          "workspaces, 1, 5, smoothOut, slide"
        ];
      };

      "$mod" = "SUPER";
      
      bind = [
        # Terminal - Kitty!
        "$mod, Return, exec, kitty"
        
        # Window management
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, Space, togglefloating"
        "$mod, D, exec, wofi --show drun"
        
        # Focus (vim keys)
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        
        # Move windows
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        
        # Screenshots (Wayland)
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, Print, exec, grim - | swappy -f -"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Laptop media keys
      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Environment for Wayland
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
      ];
    };
  };
}
