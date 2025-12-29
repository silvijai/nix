{ inputs, ... }:
{
  flake.darwinConfigurations = {
    "Viliuss-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      
      modules = [
        ../darwin/configuration.nix
        
        inputs.home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.silvija = import ../home/darwin.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      
      specialArgs = { 
        inherit inputs;
        username = "silvija";
      };
    };
  };
}
