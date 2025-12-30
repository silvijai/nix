{ inputs, pkgs, lib, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  # Fully declarative Flatpaks
  services.flatpak = {
    enable = true;
    packages = (import ../shared/packages/cross-platform-apps.nix { inherit pkgs lib; }).flatpaks;
  };
}

