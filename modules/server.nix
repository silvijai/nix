{ config, pkgs, user, ... }:
{
  # Latest kernel for best hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable power management for 24/7 operation
  powerManagement.enable = false;

  # Laptop server: ignore lid closing
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    HandleLidSwitchDocked=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    IdleAction=ignore
  '';

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  # Create server user
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    description = "MAID Server User";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6q2rj/38D17KJnS6xkeXG20SIqMrer7NPxxx0cWIQY u0_a479@localhost"
    ];
  };
  
  # Allow passwordless sudo for server user
  security.sudo.extraRules = [{
    users = [ user ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}

