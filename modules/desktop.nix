{ config, pkgs, user, ... }:
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
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
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # XDG portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Desktop packages
  environment.systemPackages = with pkgs; [
    # Hyprland essentials
    waybar
    wofi
    dunst
    swww
    
    # System utilities
    brightnessctl
    pamixer
    playerctl
    wl-clipboard
    grim
    slurp
    swappy
    
    # File manager
    thunar
    
    # Terminal
    alacritty
    
    # Theme
    catppuccin-gtk
    papirus-icon-theme
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  # Create desktop user
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
    ];
  };

  # Power management for laptops
  powerManagement.enable = true;
  services.tlp.enable = true;
}

