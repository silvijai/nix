{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".local/bin/sway" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      RED='\033[0;31m'
      NC='\033[0m'

      QEMU="${pkgs.qemu}/bin/qemu-system-aarch64"
      BIOS="${pkgs.qemu}/share/qemu/edk2-aarch64-code.fd"
      VARS_TEMPLATE="${pkgs.qemu}/share/qemu/edk2-arm-vars.fd"
      VARS="$HOME/.local/share/nixos-vm-vars.fd"

      # Initialize UEFI vars if they don't exist
      if [ ! -f "$VARS" ]; then
          echo -e "''${YELLOW}📝 Initializing UEFI vars...''${NC}"
          mkdir -p "$(dirname "$VARS")"
          cp "$VARS_TEMPLATE" "$VARS"
          chmod +w "$VARS"
      fi

      echo -e "''${BLUE}🔒 Preparing OS partitions (unmounting from macOS)...''${NC}"
      # We ONLY unmount the NixOS partitions (Boot & Root)
      # This is REQUIRED because macOS and NixOS cannot 'write' to the same raw block at once.
      diskutil unmount /dev/disk0s5 2>/dev/null || true
      diskutil unmount /dev/disk0s7 2>/dev/null || true

      echo -e "''${BLUE}🚀 Starting NixOS (Requires sudo for raw disk access)...''${NC}"
      echo ""

      # Use 'sudo' here to grant QEMU access to /dev/rdisk0sX
      sudo "$QEMU" \
        -machine virt,accel=hvf,highmem=on \
        -cpu host \
        -smp 4 \
        -m 8G \
        -drive if=pflash,format=raw,unit=0,file="$BIOS",readonly=on \
        -drive if=pflash,format=raw,unit=1,file="$VARS" \
        -device virtio-blk-pci,drive=drive-boot,logical_block_size=4096,physical_block_size=4096 \
        -drive file=/dev/rdisk0s5,if=none,id=drive-boot,format=raw,cache=none \
        -device virtio-blk-pci,drive=drive-root,logical_block_size=4096,physical_block_size=4096 \
        -drive file=/dev/rdisk0s7,if=none,id=drive-root,format=raw,cache=none \
        -virtfs local,path=/Volumes/Shared,mount_tag=host-shared,security_model=none,id=host-shared \
        -device virtio-gpu-pci \
        -display cocoa,full-screen=on,show-cursor=on \
        -device virtio-net-pci,netdev=net0 \
        -netdev user,id=net0 \
        -device virtio-keyboard-pci \
        -device virtio-tablet-pci \
        -device intel-hda -device hda-duplex \
        -serial stdio
    '';
  };
}
