{ inputs, ... }:
{
  flake = {
    homeConfigurations."fedora-asahi" = inputs.home-manager.lib.homeManagerConfiguration {
      # 1. Force aarch64-linux packages for Asahi
      pkgs = import inputs.nixpkgs { 
        system = "aarch64-linux"; 
        config.allowUnfree = true; 
      };
      
      # 2. Pass inputs so your modules can use them
      extraSpecialArgs = { inherit inputs; };
      
      # 3. Import your host module
      modules = [
        ../hosts/fedora-asahi/configuration.nix
        # If your configuration.nix already imports desktop-asahi.nix, you are good.
        # Otherwise, import it directly here:
        # ../home/desktop-asahi.nix
      ];
    };
  };
}

