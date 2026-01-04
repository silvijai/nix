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

      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      RED='\033[0;31m'
      NC='\033[0m'

      # Use Homebrew QEMU
      QEMU="/opt/homebrew/bin/qemu-system-aarch64"
      BIOS="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
      VARS="/tmp/nixos-sway-vars. fd"

      if [ ! -x "$QEMU" ]; then
          echo -e "''${RED}❌ QEMU not found. Run: brew install qemu''${NC}"
          exit 1
      fi

      # Create persistent UEFI variables if they don't exist
      # This allows the VM to remember boot entries
      if [ ! -f "$VARS" ]; then
          cp "/opt/homebrew/share/qemu/edk2-arm-vars.fd" "$VARS"
          chmod +w "$VARS"
      fi

      # Unmount partitions from macOS
      echo -e "''${BLUE}🔒 Preparing partitions (unmounting from macOS)...''${NC}"
      diskutil unmount /dev/disk0s7 2>/dev/null || true
      diskutil unmount /dev/disk0s5 2>/dev/null || true

      echo -e "''${BLUE}🚀 Starting NixOS...''${NC}"
      echo -e "''${YELLOW}If you see a Shell prompt, type 'exit' or check 'Boot Manager' ''${NC}"
      echo ""

      # Run QEMU with 4K alignment and raw access optimizations
      "$QEMU" \
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
        -display cocoa \
        -device virtio-net-pci,netdev=net0 \
        -netdev user,id=net0 \
        -device usb-ehci \
        -device usb-kbd \
        -device usb-tablet \
        -vga none \
        -serial stdio
    '';
  };

  home.sessionPath = ["$HOME/. local/bin"];
}
