{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.supportedFilesystems = ["btrfs"];

  boot = {
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

  ileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = ["nofail"]; # Add nofail here too just in case
  };

  # PHYSICAL MOUNT (Use only when NOT in a VM)
  fileSystems."/mnt/Shared" = lib.mkIf (!config.services.qemuGuest.enable) {
    device = "/dev/disk/by-label/Shared";
    fsType = "exfat";
    options = ["nofail" "x-systemd.automount" "uid=1000" "gid=100" "umask=0022"];
  };

  # VM MOUNT (Use only when in a QEMU VM)
  systemd.mounts = [
    {
      description = "Mount Shared folder from macOS Host";
      where = "/mnt/Shared";
      what = "host-shared";
      type = "9p";
      options = "trans=virtio,version=9p2000.L,msize=1048576";
      unitConfig.ConditionVirtualization = "qemu";
      wantedBy = ["multi-user.target"]; # Ensure it starts on boot
    }
  ];

  # Make sure QEMU guest services are detected
  services.qemuGuest.enable = lib.mkDefault true;

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
