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

  # Rest of your aliases unchanged...
  programs.zsh.shellAliases = {
    # ... your existing aliases
  };
}

