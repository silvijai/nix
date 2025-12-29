{ config, pkgs, inputs, ... }:
{
  imports = [ 
    ./common.nix
  ];

  home.username = "MAID0";
  home.homeDirectory = "/home/MAID0";

  home.packages = with pkgs; [
    docker-compose
    btop
    ncdu
    iotop
    lsof
  ];

  programs.zsh.shellAliases = {
    ls = "eza --group-directories-first";
    ll = "eza -l --group-directories-first";
    
    # Fixed path - no ~/nix
    update = "sudo nixos-rebuild switch --flake /home/MAID0/nix#nixos-server";
    logs = "journalctl -xef";
    syslog = "journalctl -xe";
    
    dc = "docker-compose";
    dps = "docker ps";
    dlogs = "docker-compose logs -f";
    
    ports = "netstat -tulpn";
    disk = "df -h";
    mem = "free -h";
  };

  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
    };
  };
}
