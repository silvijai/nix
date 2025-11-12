{ inputs, ... }:
let
  mkNixosSystem = { hostname, modules, homeModule, user }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        # Allow unfree at system level
        { nixpkgs.config.allowUnfree = true; }
        
        # Hardware config
        ({ lib, ... }: {
          imports = lib.optional 
            (builtins.pathExists /etc/nixos/hardware-configuration.nix)
            /etc/nixos/hardware-configuration.nix;
        })
        
        # FIXED: Use correct relative path from parts/ directory
        ../hosts/${hostname}/configuration.nix
        ../modules/nixos-common.nix
      ] ++ modules ++ [
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
    nixos-server = mkNixosSystem {
      hostname = "nixos-server";
      modules = [ ../modules/server.nix ];  # FIXED: Add ../
      homeModule = ../home/server.nix;      # FIXED: Add ../
      user = "MAID0";
    };
    
    linux-laptop = mkNixosSystem {
      hostname = "linux-laptop";
      modules = [ ../modules/desktop.nix ];  # FIXED: Add ../
      homeModule = ../home/desktop.nix;      # FIXED: Add ../
      user = "viliusi";
    };
  };
}
