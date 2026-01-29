{
  config,
  pkgs,
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

      # Paths (Ensure these match your nix-darwin setup)
      QEMU="/opt/homebrew/bin/qemu-system-aarch64"
      BIOS="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
      VARS="$HOME/.local/share/nixos-vm-vars.fd"

      # 1. Initialize UEFI vars if missing
      if [ ! -f "$VARS" ]; then
          echo -e "''${YELLOW}📝 Initializing UEFI vars...''${NC}"
          mkdir -p "$(dirname "$VARS")"
          cp "/opt/homebrew/share/qemu/edk2-arm-vars.fd" "$VARS"
          chmod +w "$VARS"
      fi

      # 2. Unmount the OS partitions (Required for safety)
      echo -e "''${BLUE}🔒 Unmounting OS partitions from macOS...''${NC}"
      sudo diskutil unmount /dev/disk0s5 || true  # EFI
      sudo diskutil unmount /dev/disk0s7 || true  # NixOS Root

      echo -e "''${BLUE}🚀 Starting NixOS...''${NC}"

      # 3. Start QEMU using partition-level access
      # disk0s5 will show up as /dev/vda, disk0s7 as /dev/vdb
      sudo "$QEMU" \
        -machine virt,accel=hvf,highmem=on \
        -cpu host \
        -smp 4 \
        -m 8G \
        -drive if=pflash,format=raw,unit=0,file="$BIOS",readonly=on \
        -drive if=pflash,format=raw,unit=1,file="$VARS" \
        -device virtio-blk-pci,drive=drive-boot \
        -drive file=/dev/rdisk0s5,if=none,id=drive-boot,format=raw,cache=none \
        -device virtio-blk-pci,drive=drive-root \
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
