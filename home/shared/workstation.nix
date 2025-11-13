{ config, pkgs, lib, ... }:
let
  apps = import ./packages/cross-platform-apps.nix { inherit pkgs lib; };
  
  # Architecture detection
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  
  # x86-only packages to exclude on ARM
  x86OnlyPackages = [ "steam" "wine" "winetricks" "lutris" ];
  
  # Filter function
  filterForArch = packageList:
    if isAarch64 then
      builtins.filter (pkg: 
        !(builtins.elem (lib.getName pkg) x86OnlyPackages)
      ) packageList
    else packageList;
      
  # Filtered lists
  compatibleBoth = filterForArch apps.both;
  compatibleLinuxNix = filterForArch apps.linuxNix;
in
{
  imports = [
    ./nixvim.nix
    ./shell.nix
    ./apps/kitty.nix
  ];

  # ONLY CHANGE: Replace your home.packages line with:
  home.packages = compatibleBoth
    ++ lib.optionals pkgs.stdenv.isLinux (
      compatibleLinuxNix 
      ++ [ apps.flatpakInstallScript ]
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
