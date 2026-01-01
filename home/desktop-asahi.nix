{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./desktop.nix
    ./shared/asahi-shared-drive.nix
    ./flatpak.nix
  ];

  # Apps from cross-platform
  home.packages = (import ./shared/packages/cross-platform-apps.nix { inherit pkgs lib; }).linuxNix;

  # KDE Plasma integration
  # programs.plasma.enable = true;

  # Sway session (optional alongside KDE)
  wayland.windowManager.sway.enable = true;
}

