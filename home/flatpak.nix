{ inputs, pkgs, lib, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];  # ✅ Correct path
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";  # ✅ Fix warning
  };

  # Fully declarative Flatpaks
  services.flatpak = {
    enable = true;
    packages = (import ../shared/packages/cross-platform-apps.nix { inherit pkgs lib; }).flatpaks;
  };
}

