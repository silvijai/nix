{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable guest services to detect VM environment
  services.qemuGuest.enable = lib.mkDefault true;

  # VM SHARED FOLDER (9p Protocol)
  systemd.mounts = [
    {
      description = "Mount Shared folder from macOS Host";
      where = "/mnt/Shared";
      what = "host-shared";
      type = "9p";
      options = "trans=virtio,version=9p2000.L,msize=1048576";
      unitConfig.ConditionVirtualization = "qemu";
      wantedBy = ["multi-user.target"];
    }
  ];

  # BOOTLOADER FIX: Prevent VM from trying to install to /dev/vda
  # We use mkForce to ensure the VM settings override any shared defaults
  boot.loader.nixos.enable = lib.mkIf config.services.qemuGuest.enable (lib.mkForce false);
  boot.loader.systemd-boot.enable = lib.mkIf config.services.qemuGuest.enable (lib.mkForce false);

  # Fallback kernel for VM if Asahi kernel is unavailable/incompatible
  # Usually not needed if using binary cache, but good for stability
  boot.initrd.availableKernelModules = ["virtio_pci" "virtio_blk" "virtio_net" "9p" "9pnet_virtio"];
}
