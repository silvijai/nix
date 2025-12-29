{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./fex-emu.nix  # ← Add this
  ];
  
  # Apple Silicon hardware support
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    
    # Only extract firmware if the directory exists (during actual installation)
    extractPeripheralFirmware = lib.mkDefault (builtins.pathExists ../../firmware);
    peripheralFirmwareDirectory = lib.mkIf (builtins.pathExists ../../firmware) ../../firmware;
  };

  # Binary cache
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixos-apple-silicon.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-apple-silicon.cachix.org-1:fVbPuKGzmcq4oCNq4WYJ6fXQOBLnJZGN+kLJ4RbBBFs="
    ];
  };

  # Kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_asahi;
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];
  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  # Graphics (GPU support is now in mainline Mesa)
  services.xserver.videoDrivers = [ "modesetting" ];

  # WiFi
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.networkmanager.enable = lib.mkForce false;

  # Touchpad
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

  # Power
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

