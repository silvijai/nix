{ config, pkgs, inputs, ... }:
{
  imports = [
    ./common.nix
    ./shared/development.nix
    ./shared/nixvim.nix
    ./shared/workstation.nix
    ./shared/shell.nix
  ];

  home.username = "viliusi";
  home.homeDirectory = "/home/viliusi";

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1"
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "dunst"
        "swww init"
        "swww img ~/Pictures/wallpaper.png"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # General settings (Omarchy-inspired aesthetic)
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ff) rgba(94e2d5ff) 45deg";
        "col.inactive_border" = "rgba(313244ff)";
        layout = "dwindle";  # Tiling layout
      };

      # Decorations (modern look)
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # Animations (smooth and modern)
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Key bindings (Omarchy-inspired)
      "$mod" = "SUPER";
      
      bind = [
        # Basics
        "$mod, Return, exec, alacritty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, Space, togglefloating"
        "$mod, D, exec, wofi --show drun"
        
        # Window navigation (vim keys)
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
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        
        # Scratchpad
        "$mod, S, togglespecialworkspace"
        "$mod SHIFT, S, movetoworkspace, special"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Brightness and volume (laptop controls)
      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
      ];
    };
  };

  # Waybar configuration (Omarchy-style status bar)
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            default = "";
          };
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y}";
        };
        
        battery = {
          format = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = " {essid}";
          format-disconnected = "⚠ Disconnected";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = ["" "" ""];
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      
      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #89b4fa;
      }
      
      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
      }
      
      #workspaces button.active {
        color: #89b4fa;
      }
      
      #clock, #battery, #network, #pulseaudio {
        padding: 0 10px;
      }
    '';
  };

  # Alacritty terminal (Omarchy-style)
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };
      
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 12.0;
      };
      
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        # Catppuccin Mocha theme
      };
    };
  };

  # Wofi launcher (app menu)
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
    };
  };

  # Additional Linux desktop packages
  home.packages = with pkgs; [
    # Theme tools
    catppuccin-gtk
    lxappearance  # GTK theme switcher
    
    # Wayland tools
    wl-clipboard
    wlr-randr
    
    # Screenshots/recording
    flameshot
    peek
    
    # System monitoring
    btop
    nvtop  # GPU monitoring
  ];
}

