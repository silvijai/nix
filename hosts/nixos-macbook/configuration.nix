{ config, lib, pkgs, user, ... }:
{
  system.stateVersion = "25.11";

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-macbook";

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}

