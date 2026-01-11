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
    ./vm-configuration.nix
    # Ensure this points to your apple-silicon-support flake input
    # apple-silicon-support.nixosModules.apple-silicon-support
  ];

  networking.hostName = "nixos-macbook";

  # Binary Cache for Asahi/Nix-Community (Prevents kernel rebuilds)
  nix.settings = {
    substituters = ["https://nix-community.cachix.org"];
    trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTvgyYoBDtLaPAe0kx+Ldb4Pu4pGSuilcvKH7+miTT4 viliusi@Viliuss-MacBook-Pro.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  networking.wireless.iwd.enable = true;
}
