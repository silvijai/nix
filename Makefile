.PHONY: help darwin nixos-server nixos-laptop nixos-asahi fedora-asahi vm check update clean

help:
	@echo "Available targets:"
	@echo "  darwin                - Build macOS"
	@echo "  darwin-test           - Test macOS build"
	@echo "  nixos-server          - Deploy server"
	@echo "  nixos-laptop          - Build laptop"
	@echo "  nixos-laptop-test     - Test laptop build"
	@echo "  nixos-asahi           - Build NixOS Asahi (System)"
	@echo "  nixos-asahi-test      - Test NixOS Asahi build"
	@echo "  fedora-asahi          - Apply Fedora Asahi (Home Manager)"
	@echo "  fedora-asahi-test     - Test Fedora Asahi build"
	@echo "  asahi-test-from-macos - Cross-compile test from macOS"
	@echo "  check                 - Check flake"
	@echo "  update                - Update inputs"
	@echo "  clean                 - Clean garbage"

# macOS
darwin:
	sudo darwin-rebuild switch --flake .#Viliuss-MacBook-Pro

darwin-test:
	darwin-rebuild build --flake .#Viliuss-MacBook-Pro

# NixOS Server
nixos-server:
	nixos-rebuild switch --flake .#nixos-server \
		--target-host maid-server \
		--use-remote-sudo \
		--build-host localhost

# NixOS Laptop
nixos-laptop:
	sudo nixos-rebuild switch --flake .#linux-laptop

nixos-laptop-test:
	nixos-rebuild build --flake .#linux-laptop

# NixOS Asahi
nixos-asahi:
	sudo nixos-rebuild switch --flake .#asahi-macbook

nixos-asahi-test:
	nixos-rebuild build --flake .#asahi-macbook

# Fedora Asahi (Home Manager Standalone)
fedora-asahi:
	nix run home-manager -- switch --flake .#fedora-asahi

fedora-asahi-test:
	nix build .#homeConfigurations."fedora-asahi".activationPackage

asahi-test-from-macos:
	nix build .#nixosConfigurations.asahi-macbook.config.system.build.toplevel

asahi-setup-cache:
	@if ! grep -q "nixos-apple-silicon.cachix.org" /etc/nix/nix.conf 2>/dev/null; then \
		echo "substituters = https://cache.nixos.org https://nixos-apple-silicon.cachix.org" | sudo tee -a /etc/nix/nix.conf; \
		echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixos-apple-silicon.cachix.org-1:fVbPuKGzmcq4oCNq4WYJ6fXQOBLnJZGN+kLJ4RbBBFs=" | sudo tee -a /etc/nix/nix.conf; \
	fi

# VM
vm:
	nix build .#nixosConfigurations.nixos-utm.config.system.build.vm

vm-run: vm
	./result/bin/run-nixos-utm

# Maintenance
check:
	nix flake check

update:
	nix flake update

clean:
	@echo "Cleaning up..."
	nix-collect-garbage -d
	sudo nix-collect-garbage -d
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Cleaning Homebrew..."; \
		brew cleanup -s || true; \
		brew autoremove || true; \
		echo "Cleaning old Darwin generations..."; \
		sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system || true; \
		echo "Optimizing Nix store..."; \
		nix store optimise; \
	else \
		echo "Cleaning old NixOS/Home Manager generations..."; \
		sudo nix-collect-garbage -d; \
		nix-collect-garbage -d; \
		nix store optimise; \
	fi
	@echo "Done!"

