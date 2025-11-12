{ config, pkgs, ... }:
{
  imports = [
    ../../modules/desktop-environments/omarchy-inspired.nix
  ];

  networking.hostName = "linux-laptop";
  networking.useDHCP = true;

  # Enable power management for laptop
  powerManagement.enable = true;
  services.tlp.enable = true;

  # Enable NVIDIA if needed
  # hardware.nvidia.modesetting.enable = true;

  system.stateVersion = "25.05";
}

