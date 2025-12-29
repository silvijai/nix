{ config, pkgs, lib, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Locale
  time.timeZone = lib.mkDefault "Europe/Copenhagen";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    wget
    curl
    tmux
    jq
  ];
}
