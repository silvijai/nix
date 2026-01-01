{ pkgs, lib, ... }:
let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in
{
  # Universal apps (macOS + Linux)
  both = with pkgs; [
    git
    ripgrep
    fd
    eza
    bat
    zoxide
    fzf
    tldr
    neovim
    inkscape
    audacity
    sioyek
  ];
}
