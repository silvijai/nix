{ config, pkgs, lib, ... }:
{
  networking.hostName = "nixos-server";

  # Boot configuration
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Filesystem configuration (will be overridden by hardware-configuration.nix on actual machine)
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Static IP configuration
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
    user = "MAID0";
    dataDir = "/var/lib/jellyfin/";
  };

  system.stateVersion = "25.05";
}
