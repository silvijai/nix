{ inputs, ... }:
{
  # Per-system formatter
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixpkgs-fmt;
    
    # You can also use alejandra or nixfmt
    # formatter = pkgs.alejandra;
  };
}

