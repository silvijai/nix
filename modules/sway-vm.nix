{
  config,
  pkgs,
  lib,
  ...
}: {
  home. file. ".local/bin/sway" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      VM_NAME="nixos-sway"

      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      RED='\033[0;31m'
      NC='\033[0m'

      # Function to check if partition is mounted
      check_partition_mounted() {
          local partition="$1"
          if mount | grep -q "$partition"; then
              echo -e "''${RED}❌ Error: Partition $partition is currently mounted! ''${NC}"
              echo -e "''${YELLOW}Please unmount it first or boot into NixOS on real hardware.''${NC}"
              return 1
          fi
          return 0
      }

      # Function to detect NixOS partition
      detect_nixos_partition() {
          echo -e "''${BLUE}🔍 Detecting NixOS partition...''${NC}"

          # Look for Linux filesystems
          diskutil list | grep -i "linux" || {
              echo -e "''${RED}❌ No Linux partitions found!''${NC}"
              echo "Please specify partition manually in lima-direct.yaml"
              exit 1
          }

          echo -e "''${YELLOW}⚠️  Verify the partition in ~/. lima/$VM_NAME/lima.yaml''${NC}"
      }

      # Function to unmount partition if needed
      unmount_if_needed() {
          local partition="$1"
          if mount | grep -q "$partition"; then
              echo -e "''${YELLOW}📤 Unmounting $partition...''${NC}"
              sudo diskutil unmount "$partition" || {
                  echo -e "''${RED}Failed to unmount.  Please do it manually.''${NC}"
                  exit 1
              }
          fi
      }

      # Check if Lima is installed
      if ! command -v limactl &> /dev/null; then
          echo -e "''${RED}❌ Lima not installed. Install with: brew install lima''${NC}"
          exit 1
      fi

      # Create VM if it doesn't exist
      if !  limactl list | grep -q "^$VM_NAME"; then
          echo -e "''${BLUE}📦 Creating VM configuration...''${NC}"

          # Detect partition
          detect_nixos_partition

          # Create VM
          limactl create --name="$VM_NAME" ~/nix/hosts/nixos-sway/lima-direct.yaml

          echo -e "''${YELLOW}⚠️  IMPORTANT: Edit ~/. lima/$VM_NAME/lima. yaml''${NC}"
          echo -e "''${YELLOW}   and set the correct disk device path! ''${NC}"
          read -p "Press enter when ready..."
      fi

      # Check if VM is running
      if ! limactl list | grep "^$VM_NAME" | grep -q "Running"; then
          echo -e "''${BLUE}🚀 Starting VM...''${NC}"

          # Note: You might need to unmount the partition first
          # Uncomment if needed:
          # unmount_if_needed "/dev/disk0s5"  # Change to your partition

          limactl start "$VM_NAME"
          sleep 5
      else
          echo -e "''${GREEN}✅ VM already running''${NC}"
      fi

      # Launch Sway
      echo -e "''${GREEN}🪟 Launching Sway... ''${NC}"

      # Since you have existing Asahi setup, user might be different
      # Adjust username if needed
      limactl shell "$VM_NAME" sudo -u silvijai bash -c '
          export XDG_RUNTIME_DIR=/run/user/$(id -u)
          export WAYLAND_DISPLAY=wayland-1

          # If Sway is already running, connect to it
          if pgrep -x sway > /dev/null; then
              swaymsg
          else
              exec sway
          fi
      '
    '';
  };

  home.file.".local/bin/detect-nixos-partition" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      echo "Looking for Linux partitions..."
      echo ""

      diskutil list | grep -B 5 -A 2 -i "linux"

      echo ""
      echo "To get detailed info about a partition:"
      echo "  diskutil info /dev/diskXsY"
      echo ""
      echo "To check if NixOS:"
      echo "  sudo file -s /dev/diskXsY"
      echo "  sudo blkid /dev/diskXsY"
    '';
  };

  home.file.".local/bin/sway-mount-check" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Check what's mounted
      echo "Currently mounted partitions:"
      mount | grep "^/dev"

      echo ""
      echo "Lima VMs:"
      limactl list
    '';
  };

  home.sessionPath = ["$HOME/.local/bin"];
}
