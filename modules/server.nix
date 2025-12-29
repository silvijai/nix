{ config, pkgs, lib, user, ... }:
{
  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable power management
  powerManagement.enable = false;

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleSuspendKey = "ignore";
      HandleHibernateKey = "ignore";
      IdleAction = "ignore";
    };
  }; 

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  # Create server user
  users.users.${user} = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$RJ6rQzBdZ80HYDi1PMtDP1$qRG2B4I/G/PPOl4FOs1LSDDGgU0d5TKCRqqxE7M9pq7";
    home = "/home/${user}";
    description = "MAID Server User";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6q2rj/38D17KJnS6xkeXG20SIqMrer7NPxxx0cWIQY u0_a479@localhost"
    ];
  };
  
  # Passwordless sudo
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
    autoPrune.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
