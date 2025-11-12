{ config, pkgs, ... }:
{
  networking.hostName = "nixos-server";

  # Static IP configuration (from your original config)
  networking = {
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
    firewall.allowedUDPPorts = [ 9 ]; # Wake-on-LAN
  };

  # Audio (for Jellyfin transcoding)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "25.05";
}
