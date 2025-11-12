{ config, pkgs, inputs, ... }:
{
  imports = [ 
    ./common.nix
    # NO development tools - keep server lean
  ];

  home.username = "MAID0";
  home.homeDirectory = "/home/MAID0";

  # Server-only packages
  home.packages = with pkgs; [
    docker-compose
    btop
    ncdu
    iotop
    lsof
  ];

  # Server management aliases
  programs.zsh.shellAliases = {
    # Simpler ls for server
    ls = "eza --group-directories-first";
    ll = "eza -l --group-directories-first";
    
    # Server operations
    update = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos-server";
    logs = "journalctl -xef";
    syslog = "journalctl -xe";
    
    # Docker
    dc = "docker-compose";
    dps = "docker ps";
    dlogs = "docker-compose logs -f";
    
    # Monitoring
    ports = "netstat -tulpn";
    disk = "df -h";
    mem = "free -h";
  };

  # Simple vim for quick server edits (not full nixvim)
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
    };
  };
}

