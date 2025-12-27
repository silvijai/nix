.PHONY: help darwin nixos-server nixos-laptop vm check update clean fmt

# Default target
help:
	@echo "MAID Nix Configuration Management"
	@echo ""
	@echo "Available targets:"
	@echo "  make darwin         - Build and switch macOS configuration"
	@echo "  make nixos-server   - Deploy to NixOS server (remote)"
	@echo "  make nixos-laptop   - Build NixOS laptop configuration"
	@echo "  make vm             - Build and run NixOS VM in UTM"
	@echo "  make check          - Check flake validity"
	@echo "  make update         - Update flake inputs"
	@echo "  make fmt            - Format all nix files"
	@echo "  make clean          - Clean build artifacts and old generations"

# macOS
darwin:
	@echo "Rebuilding macOS configuration..."
	sudo darwin-rebuild switch --flake .#Viliuss-MacBook-Pro

darwin-test:
	@echo "Testing macOS configuration (no switch)..."
	darwin-rebuild build --flake .#Viliuss-MacBook-Pro

# NixOS Server (deploy from Mac)
nixos-server:
	@echo "Deploying to NixOS server..."
	nixos-rebuild switch --flake .#nixos-server \
		--target-host maid-server \
		--use-remote-sudo \
		--build-host localhost

nixos-server-test:
	@echo "Testing server configuration..."
	nixos-rebuild build --flake .#nixos-server

# NixOS Laptop
nixos-laptop:
	@echo "Building NixOS laptop configuration..."
	sudo nixos-rebuild switch --flake .#linux-laptop

# VM for testing
vm:
	@echo "Building NixOS VM..."
	nix build .#nixosConfigurations.nixos-vm.config.system.build.vm
	@echo "VM built! Run with: ./result/bin/run-nixos-vm"

vm-run: vm
	@echo "Starting VM..."
	./result/bin/run-nixos-vm

# Maintenance
check:
	@echo "Checking flake..."
	nix flake check

update:
	@echo "Updating flake inputs..."
	nix flake update	

fmt:
	@echo "Formatting nix files..."
	nix fmt

clean:
	@echo "Cleaning up..."
	nix-collect-garbage -d
	@if [ "$$(uname)" = "Darwin" ]; then \
		darwin-rebuild --list-generations | tail -5; \
	fi

# Show current system info
info:
	@echo "System Information"
	@echo "--------------------"
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "System: macOS"; \
		echo "Hostname: $$(hostname)"; \
		echo "Generation: $$(darwin-rebuild --list-generations | tail -1)"; \
	else \
		echo "System: NixOS"; \
		echo "Hostname: $$(hostname)"; \
		nixos-version; \
	fi
	@echo ""
	@echo "Flake inputs:"
	@nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.key != "root") | "  \(.key): \(.value.locked.rev[0:7])"'

# Git helpers
commit:
	@echo "Committing changes..."
	git add .
	git status
	@read -p "Commit message: " msg; \
	git commit -m "$$msg"

sync: commit
	@echo "Syncing with remote..."
	git push
