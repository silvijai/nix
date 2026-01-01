{ inputs, ... }:
let
  # New helper for non-NixOS Linux + Nix (Home Manager standalone)
  mkNixLinuxSystem = { hostname, system ? "x86_64-linux", homeModule, user }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      
      modules = [
        ../modules/nix-common.nix  # Shared Nix setup (if exists, or create)
        homeModule
      ];
      
      extraSpecialArgs = { inherit inputs user; };
    };
in
{
  # New: Standalone Home Manager configs for non-NixOS Linux
  flake.homeConfigurations = {
    "silvija@linux-desktop" = mkNixLinuxSystem {
      hostname = "linux-desktop";
      system = "x86_64-linux";
      homeModule = ../home/desktop.nix;
      user = "silvija";
    };

    "silvija@fedora-asahi-mac" = mkNixLinuxSystem {
      hostname = "fedora-asahi-mac";
      system = "aarch64-linux";
      homeModule = ../home/desktop-asahi.nix;  # Reuse Asahi-tuned home config
      user = "silvija";
    };
  };
}
