.PHONY: help darwin darwin-test \
        nixos-server nixos-server-test \
        nixos-laptop nixos-laptop-test \
        nixos-macbook nixos-macbook-test \
        nixos-utm-x86 nixos-utm-x86-test \
        nixos-utm-aarch nixos-utm-aarch-test \
        vm vm-run \
        check update clean

# ----- Help -----

help:
	@echo "Available targets:"
	@echo "  darwin                - Deploy macOS (nix-darwin)"
	@echo "  darwin-test           - Build macOS config only"
	@echo "  nixos-server          - Deploy NixOS server (remote)"
	@echo "  nixos-server-test     - Build NixOS server config"
	@echo "  nixos-laptop          - Deploy NixOS laptop"
	@echo "  nixos-laptop-test     - Build NixOS laptop config"
	@echo "  nixos-macbook         - Deploy NixOS Asahi on MacBook"
	@echo "  nixos-macbook-test    - Build NixOS Asahi config"
	@echo "  nixos-utm-x86         - Deploy x86_64 NixOS UTM VM"
	@echo "  nixos-utm-x86-test    - Build x86_64 NixOS UTM VM config"
	@echo "  nixos-utm-aarch       - Deploy aarch64 NixOS UTM VM"
	@echo "  nixos-utm-aarch-test  - Build aarch64 NixOS UTM VM config"
	@echo "  vm                    - Build default NixOS UTM VM"
	@echo "  vm-run                - Run default NixOS UTM VM"
	@echo "  check                 - nix flake check"
	@echo "  update                - nix flake update"
	@echo "  clean                 - GC + store optimise"


# ----- macOS (Darwin) -----

darwin:
	sudo darwin-rebuild switch --flake .#Silvijas-Macbook

darwin-test:
	darwin-rebuild build --flake .#Silvijas-Macbook


# ----- NixOS: server (remote) -----

nixos-server:
	nixos-rebuild switch --flake .#nixos-server \
		--target-host maid-server \
		--use-remote-sudo \
		--build-host localhost

nixos-server-test:
	nixos-rebuild build --flake .#nixos-server


# ----- NixOS: laptop (bare metal) -----

nixos-laptop:
	sudo nixos-rebuild switch --flake .#linux-laptop

nixos-laptop-test:
	nixos-rebuild build --flake .#linux-laptop


# ----- NixOS: Asahi MacBook (bare metal) -----

nixos-macbook:
	sudo nixos-rebuild switch --flake .#nixos-macbook

nixos-macbook-test:
	nixos-rebuild build --flake .#nixos-macbook


# ----- NixOS: UTM VMs -----

nixos-utm-x86:
	sudo nixos-rebuild switch --flake .#nixos-utm-x86

nixos-utm-x86-test:
	nixos-rebuild build --flake .#nixos-utm-x86

nixos-utm-aarch:
	sudo nixos-rebuild switch --flake .#nixos-utm-aarch

nixos-utm-aarch-test:
	nixos-rebuild build --flake .#nixos-utm-aarch


# Default VM build (uses nixos-utm-aarch by convention)

vm:
	nix build .#nixosConfigurations.nixos-utm-aarch.config.system.build.vm

vm-run: vm
	./result/bin/run-nixos-vm || ./result/bin/run-nixos-utm || true


# ----- Maintenance -----

check:
	nix flake check --all-systems

update:
	nix flake update

clean:
	@echo "Cleaning up..."
	nix-collect-garbage -d || true
	sudo nix-collect-garbage -d || true
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Cleaning old Darwin generations..."; \
		sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system || true; \
	fi
	nix store optimise || true
	@echo "Done!"
