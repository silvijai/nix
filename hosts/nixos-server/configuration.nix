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

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1a2fddc4-604a-4192-939b-74684b2e0042";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/084ac1c4-eabd-4fdf-9a3e-dc36c1c312bb"; }
    ];

  # static IP Adress
  networking = {
    hostName = "nixos";
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
    firewall.allowedUDPPorts = [ 9 ];
  };

  # Audio (for Jellyfin transcoding)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  system.stateVersion = "25.05";
}
