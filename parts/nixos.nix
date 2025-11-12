{ inputs, ... }:
let
  # Helper to build NixOS systems
  mkNixosSystem = { hostname, modules, homeModule, user }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        # Hardware config (stays on machine, not in git)
        ({ lib, ... }: {
          imports = lib.optional 
            (builtins.pathExists /etc/nixos/hardware-configuration.nix)
            /etc/nixos/hardware-configuration.nix;
        })
        
        # Host-specific configuration
        ../hosts/${hostname}/configuration.nix
        
        # Common NixOS modules
        ../modules/nixos-common.nix
      ] ++ modules ++ [
        # Home Manager
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
    # Server (your current laptop)
    nixos-server = mkNixosSystem {
      hostname = "nixos-server";
      modules = [ ../modules/server.nix ];
      homeModule = ../home/server.nix;
      user = "MAID0";
    };
    
    # Future Linux laptop
    linux-laptop = mkNixosSystem {
      hostname = "linux-laptop";
      modules = [ ../modules/desktop.nix ];
      homeModule = ../home/desktop.nix;
      user = "viliusi";
    };
  };
}

