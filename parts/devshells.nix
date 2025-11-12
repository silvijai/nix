{ inputs, ... }:
{
  perSystem = { config, pkgs, system, ... }: {
    # Default dev shell
    devShells.default = pkgs.mkShell {
      name = "maid-dev";
      
      packages = with pkgs; [
        # Nix tools
        nixpkgs-fmt
        nil  # Nix LSP
        
        # Version control
        git
        
        # Utilities
        jq
        curl
      ];
      
      shellHook = ''
        echo "🏠 MAID Development Environment"
        echo "Available commands:"
        echo "  nix fmt         - Format all nix files"
        echo "  nix flake check - Check flake validity"
        echo ""
        echo "Deploy commands:"
        echo "  darwin-rebuild switch --flake ."
        echo "  nixos-rebuild switch --flake .#nixos-server"
      '';
    };
    
    # Server management shell
    devShells.server = pkgs.mkShell {
      name = "maid-server";
      
      packages = with pkgs; [
        docker-compose
        htop
        btop
      ];
      
      shellHook = ''
        echo "🖥️  MAID Server Management Shell"
      '';
    };
  };
}

