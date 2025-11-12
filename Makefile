# Makefile for nix-darwin + Home Manager configuration

# Variables
HOSTNAME ?= $(shell hostname -s)
FLAKE = .#darwinConfigurations.$(HOSTNAME)
USER ?= $(shell whoami)

# Default target
.PHONY: all
all: switch

# Update flake inputs
.PHONY: update
update:
	nix flake update

# Dry-run: show what would change
.PHONY: dry-run
dry-run:
	darwin-rebuild build --flake $(FLAKE) --dry-run

# Build configuration
.PHONY: build
build:
	darwin-rebuild build --flake $(FLAKE)

# Build and activate (system + home manager)
.PHONY: switch
switch:
	sudo darwin-rebuild switch --flake $(FLAKE)

# Rollback to previous generation
.PHONY: rollback
rollback:
	darwin-rebuild rollback

# Show current generation
.PHONY: list-generations
list-generations:
	darwin-rebuild --list-generations

# Clean up old generations
.PHONY: clean
clean:
	sudo nix-collect-garbage -d
	darwin-rebuild --list-generations

# Format Nix files
.PHONY: fmt
fmt:
	nix fmt

# Bootstrap (first time setup)
.PHONY: bootstrap
bootstrap:
	sudo nix run nix-darwin -- switch --flake $(FLAKE)

.PHONY: hm-switch
hm-switch:
	home-manager switch --flake .#viliusi

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  update         - Update flake inputs"
	@echo "  dry-run        - Preview changes"
	@echo "  build          - Build configuration"
	@echo "  switch         - Build and activate (default)"
	@echo "  rollback       - Rollback to previous generation"
	@echo "  list-generations - Show system generations"
	@echo "  clean          - Clean old generations"
	@echo "  fmt            - Format Nix files"
	@echo "  bootstrap      - First-time setup (use once)"
	@echo "  help           - This help"

