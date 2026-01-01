{ inputs, ... }:
{
  # Per-system formatter
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixpkgs-fmt;
  };
}

