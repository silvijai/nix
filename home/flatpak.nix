{ inputs, pkgs, lib, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  
  xdg.portal.config.common.default = "*";
  
  services.flatpak = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    packages = (import ./shared/packages/linux-apps.nix { inherit pkgs lib; }).flatpaks;
  };
}

