{
  description = "Silvija's unified Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nix-darwin, apple-silicon, home-manager, nixvim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ 
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./parts/darwin.nix
        ./parts/nixos.nix
        ./parts/linux.nix
        ./parts/home.nix
        ./parts/formatter.nix
      ];

      # Allow unfree packages at flake level
      flake = {
        lib.maid = {
          users = {
            darwin = "silvija";
            linux = "silvija";
            server = "MAID0";
          };
        };
      };
      
      # Configure nixpkgs for all systems
      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
