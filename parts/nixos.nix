{ inputs, ... }:
let
  mkNixosSystem = { hostname, system ? "x86_64-linux", modules ? [], homeModule, user, isAsahi ? false }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        { networking.hostName = hostname; }
        
        ../hosts/${hostname}/configuration.nix
        ../modules/nixos-common.nix
      ] ++ modules ++ [
        # Add Apple Silicon support if Asahi
        (if isAsahi then inputs.apple-silicon.nixosModules.apple-silicon-support else {})
        
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
      system = "x86_64-linux";
      modules = [ ../modules/server.nix ];
      homeModule = ../home/server.nix;
      user = "MAID0";
    };
    
    linux-laptop = mkNixosSystem {
      hostname = "linux-laptop";
      system = "x86_64-linux";
      modules = [ ../modules/desktop.nix ];
      homeModule = ../home/desktop.nix;
      user = "silvija";
    };

    nixos-utm = mkNixosSystem {
      hostname = "nixos-utm";
      system = "aarch64-linux";
      modules = [ ../modules/desktop.nix ];
      homeModule = ../home/desktop.nix;
      user = "silvija";
    };

    asahi-macbook = mkNixosSystem {
      hostname = "asahi-macbook";
      system = "aarch64-linux";
      modules = [ ../modules/desktop.nix ../modules/asahi.nix ];
      homeModule = ../home/desktop-asahi.nix;
      user = "silvija";
      isAsahi = true;
    };
  };
}
