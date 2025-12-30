{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./desktop.nix
    ./shared/asahi-shared-drive.nix
    ./flatpak.nix  # ✅ New declarative flatpak
  ];

  # Apps from cross-platform
  home.packages = (import ../shared/packages/cross-platform-apps.nix { inherit pkgs lib; }).linuxNix;

  # KDE Plasma integration
  # programs.plasma.enable = true;

  # Sway session (optional alongside KDE)
  wayland.windowManager.sway.enable = true;

  # KDE Discover auto-refreshes Flatpaks
  home.activation.kdeDiscover = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.libsForQt5.kdeconnect}/bin/kdeconnect-cli --refresh || true
  '';
}

