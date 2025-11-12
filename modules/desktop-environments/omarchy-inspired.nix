{ config, pkgs, lib, ... }:
{
  # Enable Hyprland (modern Wayland tiling compositor)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Essential desktop services
  services = {
    # Display manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Bluetooth
    blueman.enable = true;
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # System packages for Omarchy-like experience
  environment.systemPackages = with pkgs; [
    # Window manager essentials
    waybar           # Status bar
    wofi             # App launcher (rofi for Wayland)
    dunst            # Notifications
    swww             # Wallpaper daemon
    
    # System utilities
    brightnessctl    # Brightness control
    pamixer          # Audio control
    playerctl        # Media control
    wl-clipboard     # Clipboard
    grim             # Screenshots
    slurp            # Screen region selector
    swappy           # Screenshot editor
    
    # File manager
    thunar           # Or nautilus
    
    # Terminal
    alacritty
    
    # Theme
    catppuccin-gtk
    papirus-icon-theme
  ];

  # Fonts for better UI
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];
}

