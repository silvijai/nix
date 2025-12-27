{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./fex-emu.nix  # ← Add this
  ];
  
  # Apple Silicon hardware support
  hardware.asahi = {
    enable = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    
    # Use firmware from local directory (flake-compatible)
    peripheralFirmwareDirectory = ../../firmware;
    extractPeripheralFirmware = true;
  };

  # Binary cache configuration
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixos-apple-silicon.cachix.org"  # ← Apple Silicon cache
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-apple-silicon.cachix.org-1:fVbPuKGzmcq4oCNq4WYJ6fXQOBLnJZGN+kLJ4RbBBFs="  # ← Apple Silicon key
    ];
  };

  # Asahi-specific kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_asahi;

  # Preserve notch area
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];

  # Graphics for Wayland
  services.xserver.videoDrivers = [ "modesetting" ];

  # WiFi (recommended for Asahi)
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Disable NetworkManager if using iwd
  networking.networkmanager.enable = lib.mkForce false;
  networking.networkmanager.wifi.backend = "iwd";

  # Touchpad (Mac-style)
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      accelProfile = "adaptive";
      clickMethod = "clickfinger";
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # Power management (disable TLP, conflicts with Asahi)
  services.tlp.enable = lib.mkForce false;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Touchbar support (if you have a model with touchbar)
  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
  };
}

