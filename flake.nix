{
  description = "Multi-system configuration with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Flake-parts for modular configuration
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
      # Define systems we support
      systems = [ 
        "aarch64-darwin"  # Apple Silicon Macs
        "x86_64-linux"    # Intel/AMD Linux
      ];

      # Import flake-parts modules
      imports = [
        ./parts/darwin.nix
        ./parts/nixos.nix
        ./parts/home.nix
        ./parts/formatter.nix
        ./parts/devshells.nix
      ];

      # Global configuration available to all parts
      flake = {
        # You can define shared values here
        lib.maid = {
          users = {
            darwin = "viliusi";
            linux = "silvija";
            server = "MAID0";
          };
        };
      };
    };
}

