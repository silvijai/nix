{ config, pkgs, lib, user, ... }:
{
  # Enable Hyprland (Wayland compositor)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";  # Changed this line
        user = "greeter";
      };
    };
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Polkit
  security.polkit.enable = true;

  # XDG portal - SINGLE DEFINITION
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = ["wlr" "gtk"];  # Only one definition!
  };

  # Flatpak
  services.flatpak.enable = true;

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs; [
    waybar
    wofi
    dunst
    swww
    wl-clipboard
    wlr-randr
    wtype
    ydotool
    grim
    slurp
    swappy
    wf-recorder
    brightnessctl
    pamixer
    playerctl
    kitty
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    flatpak
    xwayland
    xorg.xeyes
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Create user
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
    ];
  };

  # Power management
  powerManagement.enable = true;
  services.tlp.enable = true;

  # Real-time audio
  security.rtkit.enable = true;
  
  # dconf
  programs.dconf.enable = true;
  
  # Wayland environment variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XCURSOR_SIZE = "24";
  };
}
