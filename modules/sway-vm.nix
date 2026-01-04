{
  config,
  pkgs,
  lib,
  ...
}: {
  home. packages = with pkgs; [
    lima
    qemu # Need QEMU for raw disk access
  ];

  home.  file. ". local/bin/sway-test" = {
    executable = true;
    text = ''
            #!/usr/bin/env bash
            set -euo pipefail

            VM_NAME="nixos-sway"
            LIMA_CONFIG="$HOME/nix/hosts/nixos-sway/lima.yaml"

            GREEN='\033[0;32m'
            BLUE='\033[0;34m'
            YELLOW='\033[1;33m'
            RED='\033[0;31m'
            NC='\033[0m'

            # Safety checks
            safety_checks() {
                echo -e "''${BLUE}🔒 Running safety checks...''${NC}"

                # Check if partition is mounted
                if mount | grep -q "disk0s7"; then
                    echo -e "''${YELLOW}⚠️  Warning: NixOS partition is mounted''${NC}"
                    echo -e "''${YELLOW}   Unmounting for safe VM access...''${NC}"
                    sudo diskutil unmount /dev/disk0s7 || {
                        echo -e "''${RED}Failed to unmount.  Please unmount manually.''${NC}"
                        exit 1
                    }
                fi

                if mount | grep -q "disk0s5"; then
                    sudo diskutil unmount /dev/disk0s5
                fi

                # Check not booted into NixOS
                if [ -f /etc/NIXOS ]; then
                    echo -e "''${RED}❌ Currently booted into NixOS! ''${NC}"
                    exit 1
                fi

                echo -e "''${GREEN}✅ Safety checks passed''${NC}"
            }

            # Check config exists
            check_config() {
                if [ ! -f "$LIMA_CONFIG" ]; then
                    echo -e "''${RED}❌ Config not found:  $LIMA_CONFIG''${NC}"
                    exit 1
                fi
            }

            # Create VM
            create_vm() {
                if !  limactl list 2>/dev/null | grep -q "^$VM_NAME"; then
                    echo -e "''${BLUE}📦 Creating VM... ''${NC}"

                    # Need sudo for raw disk access
                    echo -e "''${YELLOW}⚠️  Sudo required for raw disk access''${NC}"
                    sudo limactl create --name="$VM_NAME" "$LIMA_CONFIG"
                fi
            }

            # Start VM
            start_vm() {
                if ! limactl list | grep "^$VM_NAME" | grep -q "Running"; then
                    echo -e "''${BLUE}🚀 Starting VM...''${NC}"
                    sudo limactl start "$VM_NAME"

                    echo -e "''${BLUE}⏳ Waiting for boot...''${NC}"
                    sleep 10

                    echo -e "''${GREEN}✅ VM started''${NC}"
                else
                    echo -e "''${GREEN}✅ VM already running''${NC}"
                fi
            }

            # Launch Sway
            launch_sway() {
                echo -e "''${GREEN}🪟 Launching Sway... ''${NC}"

                limactl shell "$VM_NAME" bash <<'EOF'
                  export XDG_RUNTIME_DIR=/run/user/$(id -u)
                  export WAYLAND_DISPLAY=wayland-1

                  # Check if sway exists
                  if command -v sway &> /dev/null; then
                      exec sway
                  else
                      echo "Sway not found. Dropping to shell..."
                      exec bash
                  fi
      EOF
            }

            main() {
                safety_checks
                check_config
                create_vm
                start_vm
                launch_sway
            }

            main "$@"
    '';
  };

  # Keep other scripts from before
  home.file. ".local/bin/nixos-partition-info" = {
    # Same as before
    executable = true;
    text = ''
      #!/usr/bin/env bash
      diskutil list
    '';
  };

  home. file.".local/bin/sway-vm-stop" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "🛑 Stopping VM..."
      sudo limactl stop nixos-sway
      echo "✅ Stopped"
    '';
  };

  home.sessionPath = ["$HOME/.local/bin"];
}
