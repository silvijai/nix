{ inputs, ... }:
{
  flake.homeConfigurations."silvija@fedora-asahi" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "aarch64-linux"; config.allowUnfree = true; };
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ../hosts/fedora-asahi/configuration.nix
      # inputs.nix-flatpak.homeManagerModules.default
    ];
  };
}

