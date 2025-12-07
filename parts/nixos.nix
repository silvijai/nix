{ inputs, ... }:
let
  # Helper function to create NixOS systems with flexible architecture
  mkNixosSystem = { hostname, system ? "x86_64-linux", modules, homeModule, user }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;  # Use the system parameter instead of hardcoding
      
      modules = [
        # Allow unfree packages
        { nixpkgs.config.allowUnfree = true; } 
        
        # Host-specific configuration
        ../hosts/${hostname}/configuration.nix
        ../modules/nixos-common.nix
      ] ++ modules ++ [
        # Home Manager integration
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import homeModule;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      
      specialArgs = { 
        inherit inputs user;
      };
    };
in
{
  flake.nixosConfigurations = {
    # x86_64 server
    nixos-server = mkNixosSystem {
      hostname = "nixos-server";
      system = "x86_64-linux";
      modules = [ ../modules/server.nix ];
      homeModule = ../home/server.nix;
      user = "MAID0";
    };
    
    # x86_64 laptop
    linux-laptop = mkNixosSystem {
      hostname = "linux-laptop";
      system = "x86_64-linux";
      modules = [ ../modules/desktop.nix ];
      homeModule = ../home/desktop.nix;
      user = "silvija";
    };

    # aarch64 UTM VM (Apple Silicon)
    nixos-utm = mkNixosSystem {
      hostname = "nixos-utm";
      system = "x86_64-linux";
      modules = [ ../modules/desktop.nix ];
      homeModule = ../home/desktop.nix;
      user = "silvija";
    };
  };
}
