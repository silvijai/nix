{
  config,
  pkgs,
  lib,
  ...
}: {
  home. file. ". local/bin/nixos-partition-info" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      NC='\033[0m'

      echo -e "''${BLUE}=== NixOS Partition Detection ===''${NC}\n"

      echo -e "''${YELLOW}All partitions: ''${NC}"
      diskutil list

      echo -e "\n''${YELLOW}Looking for NixOS partitions:''${NC}"

      # Find partition with label "nixos"
      NIXOS_DEV=$(diskutil info -all | grep -B 10 "Volume Name: .*nixos" | grep "Device Node:" | awk '{print $3}' | head -1)

      if [ -n "$NIXOS_DEV" ]; then
          echo -e "''${GREEN}✅ Found NixOS root:  $NIXOS_DEV''${NC}"
          diskutil info "$NIXOS_DEV"
      fi

      # Find EFI partition
      EFI_DEV=$(diskutil info -all | grep -B 10 "Volume Name:.*EFI" | grep "Device Node:" | grep -v "disk0s1" | awk '{print $3}' | head -1)

      if [ -n "$EFI_DEV" ]; then
          echo -e "\n''${GREEN}✅ Found EFI boot: $EFI_DEV''${NC}"
          diskutil info "$EFI_DEV"
      fi

      # Find Shared partition
      SHARED_DEV=$(diskutil info -all | grep -B 10 "Volume Name:.*Shared" | grep "Device Node:" | awk '{print $3}' | head -1)

      if [ -n "$SHARED_DEV" ]; then
          echo -e "\n''${GREEN}✅ Found Shared: $SHARED_DEV''${NC}"
      fi

      echo -e "\n''${BLUE}=== Summary for lima-safe.yaml ===''${NC}"
      echo "Root partition: $NIXOS_DEV"
      echo "EFI partition:   $EFI_DEV"
      echo "Shared partition: $SHARED_DEV"

      echo -e "\n''${YELLOW}Update ~/nix/hosts/nixos-sway/lima-safe.yaml with these values''${NC}"
    '';
  };

  home.file.".local/bin/sway-test" = {
    executable = true;
    text = ''
            #!/usr/bin/env bash
            set -euo pipefail

            VM_NAME="nixos-sway"
            LIMA_CONFIG="$HOME/nix/hosts/nixos-sway/lima-safe.yaml"

            GREEN='\033[0;32m'
            BLUE='\033[0;34m'
            YELLOW='\033[1;33m'
            RED='\033[0;31m'
            NC='\033[0m'

            # Safety checks
            safety_checks() {
                echo -e "''${BLUE}🔒 Running safety checks...''${NC}"

                # Check if partition is mounted in macOS
                if mount | grep -q "nixos"; then
                    echo -e "''${YELLOW}⚠️  NixOS partition is mounted in macOS''${NC}"
                    echo -e "''${YELLOW}   This is OK for snapshot mode, but don't modify files!''${NC}"
                    read -p "Continue?  (y/n) " -n 1 -r
                    echo
                    if [[ !  $REPLY =~ ^[Yy]$ ]]; then
                        exit 1
                    fi
                fi

                # Check if currently booted into NixOS
                if [ -f /etc/NIXOS ]; then
                    echo -e "''${RED}❌ You're currently running NixOS!''${NC}"
                    echo -e "''${RED}   Please boot into macOS first. ''${NC}"
                    exit 1
                fi

                echo -e "''${GREEN}✅ Safety checks passed''${NC}"
            }

            # Check if Lima config is properly configured
            check_config() {
                if grep -q "disk0sX" "$LIMA_CONFIG" 2>/dev/null; then
                    echo -e "''${RED}❌ Lima config not updated!''${NC}"
                    echo -e "''${YELLOW}Run: nixos-partition-info''${NC}"
                    echo -e "''${YELLOW}Then update: $LIMA_CONFIG''${NC}"
                    exit 1
                fi
            }

            # Create VM if needed
            create_vm() {
                if ! limactl list 2>/dev/null | grep -q "^$VM_NAME"; then
                    echo -e "''${BLUE}📦 Creating VM from existing partition...''${NC}"
                    limactl create --name="$VM_NAME" "$LIMA_CONFIG"
                fi
            }

            # Start VM
            start_vm() {
                if !  limactl list | grep "^$VM_NAME" | grep -q "Running"; then
                    echo -e "''${BLUE}🚀 Starting VM (snapshot mode - safe)...''${NC}"
                    limactl start "$VM_NAME"

                    echo -e "''${BLUE}⏳ Waiting for VM to boot... ''${NC}"
                    sleep 5

                    # Wait for system to be ready
                    until limactl shell "$VM_NAME" test -d /run/user/1000 2>/dev/null; do
                        echo -n "."
                        sleep 2
                    done
                    echo -e "\n''${GREEN}✅ VM booted''${NC}"
                else
                    echo -e "''${GREEN}✅ VM already running''${NC}"
                fi
            }

            # Test connection
            test_connection() {
                echo -e "''${BLUE}🧪 Testing VM connection...''${NC}"

                limactl shell "$VM_NAME" uname -a
                limactl shell "$VM_NAME" whoami
                limactl shell "$VM_NAME" df -h /

                echo -e "''${GREEN}✅ Connection successful''${NC}"
            }

            # Launch Sway
            launch_sway() {
                echo -e "''${GREEN}🪟 Launching Sway...''${NC}"
                echo -e "''${YELLOW}   Press Mod+Shift+e to exit Sway''${NC}"
                echo -e "''${YELLOW}   This is SNAPSHOT mode - changes won't persist to dual-boot''${NC}"

                limactl shell "$VM_NAME" bash <<'EOF'
                  export XDG_RUNTIME_DIR=/run/user/$(id -u)
                  export WAYLAND_DISPLAY=wayland-1

                  # Check if Sway is installed
                  if ! command -v sway &> /dev/null; then
                      echo "❌ Sway not found in your NixOS installation"
                      echo "Boot into NixOS and install it, or rebuild config"
                      exit 1
                  fi

                  exec sway
      EOF
            }

            # Main execution
            main() {
                safety_checks
                check_config
                create_vm
                start_vm
                test_connection
                launch_sway
            }

            main "$@"
    '';
  };

  home.file.".local/bin/sway-vm-stop" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "🛑 Stopping VM..."
      limactl stop nixos-sway
      echo "✅ VM stopped"
    '';
  };

  home. file.".local/bin/sway-vm-shell" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Just get a shell in the VM
      limactl shell nixos-sway
    '';
  };

  home. file.".local/bin/sway-vm-status" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "=== Lima VMs ==="
      limactl list
      echo ""
      echo "=== Mounted Partitions ==="
      mount | grep -E "(nixos|EFI|Shared)" || echo "None"
    '';
  };

  home.sessionPath = ["$HOME/.local/bin"];
}
