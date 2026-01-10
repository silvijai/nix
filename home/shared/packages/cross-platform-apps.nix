{
  pkgs,
  lib,
  ...
}: {
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
    qemu
    virt-viewer
  ];
}
