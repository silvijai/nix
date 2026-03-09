# ──────────────────────────────────────────────
#  Silvija's Nix configuration — justfile
#  https://github.com/casey/just
# ──────────────────────────────────────────────

# Show this help message (default recipe)
default:
    @just --list --unsorted

# ── macOS (Darwin) ────────────────────────────

# Deploy macOS config (nix-darwin switch)
darwin:
    sudo darwin-rebuild switch --flake .#Silvijas-Macbook

# Dry-run: build macOS config without switching
darwin-test:
    darwin-rebuild build --flake .#Silvijas-Macbook

# Show what would change on macOS before switching
darwin-diff:
    darwin-rebuild build --flake .#Silvijas-Macbook
    nvd diff /run/current-system ./result

# Roll back nix-darwin to the previous generation
rollback-darwin:
    sudo darwin-rebuild --rollback switch

# List nix-darwin generations
generations-darwin:
    nix-env --list-generations --profile /nix/var/nix/profiles/system

# ── NixOS: server (remote) ───────────────────

# Deploy NixOS server configuration (remote host)
nixos-server:
    nixos-rebuild switch --flake .#nixos-server \
        --target-host maid-server \
        --use-remote-sudo \
        --build-host localhost

# Dry-run: build NixOS server config locally
nixos-server-test:
    nixos-rebuild build --flake .#nixos-server

# SSH into the remote server
ssh-server:
    ssh maid-server

# ── NixOS: laptop (bare metal) ───────────────

# Deploy NixOS laptop configuration
nixos-laptop:
    sudo nixos-rebuild switch --flake .#linux-laptop

# Dry-run: build NixOS laptop config
nixos-laptop-test:
    nixos-rebuild build --flake .#linux-laptop

# Show what would change on the laptop before switching
nixos-laptop-diff:
    nixos-rebuild build --flake .#linux-laptop
    nvd diff /run/current-system ./result

# ── NixOS: Asahi MacBook (bare metal) ────────

# Deploy NixOS Asahi on MacBook
nixos-macbook:
    sudo nixos-rebuild switch --flake .#nixos-macbook

# Dry-run: build NixOS Asahi config
nixos-macbook-test:
    nixos-rebuild build --flake .#nixos-macbook

# ── NixOS: UTM VMs ───────────────────────────

# Deploy x86_64 NixOS UTM VM
nixos-utm-x86:
    sudo nixos-rebuild switch --flake .#nixos-utm-x86

# Dry-run: build x86_64 NixOS UTM VM config
nixos-utm-x86-test:
    nixos-rebuild build --flake .#nixos-utm-x86

# Deploy aarch64 NixOS UTM VM
nixos-utm-aarch:
    sudo nixos-rebuild switch --flake .#nixos-utm-aarch

# Dry-run: build aarch64 NixOS UTM VM config
nixos-utm-aarch-test:
    nixos-rebuild build --flake .#nixos-utm-aarch

# Roll back NixOS to the previous generation
rollback-nixos:
    sudo nixos-rebuild --rollback switch

# List NixOS system generations
generations-nixos:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# ── VM shortcuts ─────────────────────────────

# Build the default NixOS UTM VM (aarch64)
vm:
    nix build .#nixosConfigurations.nixos-utm-aarch.config.system.build.vm

# Build and run the default NixOS UTM VM
vm-run: vm
    ./result/bin/run-nixos-vm 2>/dev/null || \
        ./result/bin/run-nixos-utm 2>/dev/null || \
        (echo "error: no runnable VM script found in ./result/bin/" && exit 1)

# ── Home Manager (standalone) ─────────────────

# Apply standalone Home Manager config (non-NixOS Linux desktop)
hm-linux:
    home-manager switch --flake .#"silvija@linux-desktop"

# Apply standalone Home Manager config (Fedora Asahi Mac)
hm-asahi:
    home-manager switch --flake .#"silvija@fedora-asahi-mac"

# ── Maintenance ───────────────────────────────

# Run nix flake check across all systems
check:
    nix flake check --all-systems

# Dry-run build ALL configurations (CI-style safety check)
test-all: darwin-test nixos-server-test nixos-laptop-test nixos-macbook-test nixos-utm-x86-test nixos-utm-aarch-test
    @echo "All configurations built successfully."

# Update all flake inputs
update:
    nix flake update

# Update a single flake input (e.g. `just lock nixpkgs`)
lock input:
    nix flake lock --update-input {{ input }}

# Format all Nix files with nix fmt
fmt:
    nix fmt

# Show all outputs exposed by the flake
show:
    nix flake show

# Open a Nix REPL with this flake loaded
repl:
    nix repl --expr 'builtins.getFlake (toString ./.)'

# Garbage-collect and optimise the Nix store
clean:
    @echo "Collecting garbage (user)..."
    -nix-collect-garbage -d
    @echo "Collecting garbage (root)..."
    -sudo nix-collect-garbage -d
    @if [ "$$(uname)" = "Darwin" ]; then \
        echo "Removing old nix-darwin generations..."; \
        sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system || true; \
    fi
    -nix store optimise
    @echo "Done!"
