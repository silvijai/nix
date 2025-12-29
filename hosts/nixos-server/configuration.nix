{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/server/jellyfin.nix
  ];

  users.users.root.hashedPassword = "!";

  # Boot configuration
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;  

  # static IP Adress
  networking = {
    hostName = "nixos-server";
    useDHCP = false;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [{
        address = "192.168.1.211";
        prefixLength = 24;
      }];
      wakeOnLan.enable = true;
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    firewall.allowedTCPPorts = [ 8096 ];
    firewall.allowedUDPPorts = [ 9 1900 7359 ];
  }; 

  # Audio (for Jellyfin transcoding)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  system.stateVersion = "25.05";
}
