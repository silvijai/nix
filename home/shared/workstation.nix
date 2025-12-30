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

  # ✅ FIXED: Use apps.flatpaks instead of apps.linuxFlatpak
  home.packages = apps.both
    ++ lib.optionals isLinux apps.linuxNix;

  # ✅ FIXED: flatpaks attribute name
  home.file = lib.mkIf isLinux {
    ".local/share/flatpak/apps.txt".text = lib.concatStringsSep "\n" (
      [ "# Flatpak applications to install" ] ++ apps.flatpaks  # Changed from linuxFlatpak
    );
  };

  # Flatpak install script using the apps.txt
  home.activation.flatpakApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env bash
    set -e
    if [ -f ~/.local/share/flatpak/apps.txt ]; then
      cat ~/.local/share/flatpak/apps.txt | grep -v '^#' | grep -v '^$' | xargs -r flatpak install -y flathub || true
    fi
  '';

  # Rest of your aliases unchanged...
  programs.zsh.shellAliases = {
    # ... your existing aliases
  };
}

