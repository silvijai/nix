{ config, pkgs, lib, ... }:
let
  apps = import ./packages/cross-platform-apps.nix { inherit pkgs lib; };
  linuxApps = import ./packages/darwin-apps.nix { inherit pkgs lib; };
  darwinApps = import ./packages/linux-apps.nix { inherit pkgs lib; };
  
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in
{
  imports = [
    ./apps/nixvim.nix
    ./shell.nix
    ./apps/kitty.nix
  ];

  # Workstation aliases
  programs.zsh.shellAliases = lib.mkMerge [
    {
      code = "codium";
      v = "nvim";
      vi = "nvim";
      term = "kitty";
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      update = lib.mkDefault "darwin-rebuild switch --flake /Users/viliusi/nix";
    })
    (lib.mkIf pkgs.stdenv.isLinux {
      update = lib.mkDefault "sudo nixos-rebuild switch --flake /home/viliusi/nix#linux-laptop";
      
      # Clipboard (Wayland)
      pbcopy = "wl-copy";
      pbpaste = "wl-paste";
      
      # Flatpak management
      flatpak-install = "flatpak-install";
      flatpak-update = "flatpak update -y";
      flatpak-clean = "flatpak uninstall --unused -y";
      flatpak-list = "flatpak list --app";
      
      # Check if app is using Wayland
      wayland-check = "echo 'XDG_SESSION_TYPE:' $XDG_SESSION_TYPE && echo 'WAYLAND_DISPLAY:' $WAYLAND_DISPLAY";
    })
  ];
}

