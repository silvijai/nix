{ config, pkgs, lib, ... }:
{
  networking.hostName = "linux-laptop";
  
  # Use mkDefault so NetworkManager can override if needed
  networking.useDHCP = lib.mkDefault true;

  # Boot configuration
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Filesystem (will be overridden by hardware-configuration.nix)
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
