{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # PHYSICAL DISK LAYOUT
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = ["nofail"];
  };

  # PHYSICAL SHARED PARTITION (Only when NOT in VM)
  fileSystems."/mnt/Shared" = lib.mkIf (!config.services.qemuGuest.enable) {
    device = "/dev/disk/by-label/Shared";
    fsType = "exfat";
    options = ["nofail" "x-systemd.automount" "uid=1000" "gid=100" "umask=0022"];
  };

  # BOOTLOADER (Only when booting natively on M1)
  boot.loader = lib.mkIf (!config.services.qemuGuest.enable) {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  # ASAHI HARDWARE SUPPORT (Disabled in VM)
  hardware.graphics.enable = lib.mkIf (!config.services.qemuGuest.enable) true;
  hardware.asahi = {
    gpu.enable = lib.mkDefault (!config.services.qemuGuest.enable);
    audio.enable = lib.mkDefault (!config.services.qemuGuest.enable);
    bluetooth.enable = lib.mkDefault (!config.services.qemuGuest.enable);
  };

  boot.kernelPackages = lib.mkIf (!config.services.qemuGuest.enable) pkgs.linuxPackages_asahi;
  boot.kernelParams = ["mitigations=off"];

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
