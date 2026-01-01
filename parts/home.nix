{ inputs, ... }:
{
  flake = {
    # You could export home-manager modules here
    homeModules = {
      common = import ../home/common.nix;
    };
  };
}

