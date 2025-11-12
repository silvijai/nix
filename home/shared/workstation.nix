{ config, pkgs, lib, ... }:
let
  apps = import ./packages/cross-platform-apps.nix { inherit pkgs lib; };
in
{
  imports = [
    ./apps/kitty.nix
  ];

  # Install cross-platform apps via Nix
  home.packages = apps.both
    ++ lib.optionals pkgs.stdenv.isLinux (
      apps.linuxNix ++ [ apps.flatpakInstallScript ]
    );
  
  # Flatpak apps list for Linux
  home.file = lib.mkIf pkgs.stdenv.isLinux {
    ".local/share/flatpak/apps.txt".text = lib.concatStringsSep "\n" (
      [ "# Flatpak applications to install" ] ++ apps.linuxFlatpak
    );
  };

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
