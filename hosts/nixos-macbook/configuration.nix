{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  system.stateVersion = "25.11";

  imports = [
    ./hardware-configuration.nix
    # <nixos-apple-silicon/apple-silicon-support>
  ];

  networking.hostName = "nixos-macbook";

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Bootloader (guide required)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false; # Apple firmware
  };

  # Kernel (Asahi - guide provides)
  boot.kernelPackages = pkgs.linuxPackages_asahi;
  boot.kernelParams = ["mitigations=off"]; # Performance

  # Network (WiFi fix)
  networking.wireless.iwd.enable = true;

  # Audio/GPU (guide modules)
  hardware.opengl.enable = true;
  hardware.asahi = {
    gpu.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
  };
}
