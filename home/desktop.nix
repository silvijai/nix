{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./common.nix
    ./shared/development.nix
    ./shared/workstation.nix  # Includes Kitty and Flatpak
  ];

  home.username = "silvija";
  home.homeDirectory = "/home/silvija";

  # Universal update alias (works on any NixOS system)
  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch --flake ~/nix#$(hostname)";
  };
  
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
  };

      
}
