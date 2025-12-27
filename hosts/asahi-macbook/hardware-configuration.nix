{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "usb_storage" ];
    
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  fileSystems."/mnt/Shared" = {
    device = "/dev/disk/by-label/shared";
    fsType = "exfat";
    options = [ "nofail" "x-systemd.automount" "uid=1000" "gid=100" "umask=0022" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

