{
  description = "My macOS configuration with nix-darwin + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let
      username = "viliusi";
      system = "aarch64-darwin";
      hostname = "Viliuss-MacBook-Pro";
    in {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin.nix
          
          # Integrate Home Manager
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
            
            # Pass extra arguments to home.nix
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
        
        # Pass arguments to darwin.nix
        specialArgs = { inherit inputs username; };
      };
    };
}
