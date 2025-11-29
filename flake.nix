{
  description = "MAID - Multi-system configuration with flake-parts";

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
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ 
        "aarch64-darwin"
        "x86_64-linux"
      ];

      imports = [
        ./parts/darwin.nix
        ./parts/nixos.nix
        ./parts/home.nix
        ./parts/formatter.nix
        ./parts/devshells.nix
      ];

      # Allow unfree packages at flake level
      flake = {
        lib.maid = {
          users = {
            darwin = "silvija";
            linux = "Silvia";
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
