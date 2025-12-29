{ config, pkgs, ... }:
{
  imports = [
    ../../home/desktop-asahi.nix
  ];

  home = {
    username = "silvija";
    homeDirectory = "/home/silvija";
  };
  
  # Fedora-specific override example (optional)
  targets.genericLinux.enable = true; # Often useful on non-NixOS
}

