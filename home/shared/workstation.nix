{ config, pkgs, lib, ... }:
let
  apps = import ./packages/cross-platform-apps.nix { inherit pkgs lib; };
  
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in
{
  imports = [
    ./nixvim.nix
    ./shell.nix
    ./apps/kitty.nix
  ];

  # Cross-platform packages (work on both macOS and Linux, both architectures)
  home.packages = apps.both
    ++ lib.optionals isLinux apps.linuxNix
    ++ lib.optionals isLinux [ apps.flatpakInstallScript ];

  # Flatpak apps list for Linux
  home.file = lib.mkIf isLinux {
    ".local/share/flatpak/apps.txt".text = lib.concatStringsSep "\n" (
      [ "# Flatpak applications to install" ] ++ apps.linuxFlatpak
    );
  };

  # Shell aliases
  programs.zsh.shellAliases = {
    # Universal
    code = "codium";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    term = "kitty";
  } // lib.optionalAttrs isLinux {
    # Linux-specific
    update = "sudo nixos-rebuild switch --flake ~/nix#$(hostname)";
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
    
    # Flatpak
    flatpak-install = "flatpak-install";
    flatpak-update = "flatpak update -y";
    flatpak-clean = "flatpak uninstall --unused -y";
    flatpak-list = "flatpak list --app";
    
    # Wayland check
    wayland-check = "echo 'XDG_SESSION_TYPE:' $XDG_SESSION_TYPE && echo 'WAYLAND_DISPLAY:' $WAYLAND_DISPLAY";
  } // lib.optionalAttrs isDarwin {
    # macOS-specific
    update = "darwin-rebuild switch --flake ~/nix#$(hostname)";
  };
}

