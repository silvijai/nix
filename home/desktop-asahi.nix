{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./desktop.nix
    ./shared/asahi-shared-drive.nix
    ./flatpak.nix
  ];

  # Apps from cross-platform
  home.packages = (import ./shared/packages/linux-apps.nix { inherit pkgs lib; }).linuxNix;

  # Sway session (optional alongside KDE)
  wayland.windowManager.sway.enable = true;
}

