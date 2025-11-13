{ config, pkgs, lib, ... }:
{
  imports = [
    ../../modules/server/jellyfin.nix
  ];

  # Boot configuration
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true; 

  # static IP Adress
  networking = {
    hostName = "nixos";
    useDHCP = false;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [{
        address = "192.168.1.211";
        prefixLength = 24; 
      }];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
  };

  # Wake-on-LAN
  networking = {
    interfaces = {
      enp0s31f6 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };

  # Audio (for Jellyfin transcoding)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  }; 

  system.stateVersion = "25.05";
}
