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

  # CHANGE THIS SECTION:
  fileSystems."/mnt/Shared" = {
    device = "/dev/disk/by-label/Shared";
    fsType = "exfat";
    # We add a 5-second timeout so it doesn't hang for 90 seconds in the VM
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "uid=1000"
      "gid=100"
      "umask=0022"
    ];
  };

  # ADD THIS: This handles the macOS Folder Share when in the VM
  systemd.mounts = [
    {
      description = "Mount Shared folder from macOS Host";
      where = "/mnt/Shared";
      what = "host-shared"; # This matches the 'mount_tag' in our QEMU script
      type = "9p";
      options = "trans=virtio,version=9p2000.L,msize=1048576";
      unitConfig.ConditionVirtualization = "qemu"; # Only runs in the VM!
    }
  ];

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
