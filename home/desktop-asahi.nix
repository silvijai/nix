{ config, ... }:
{
  imports = [ 
    ./desktop.nix                      # Base desktop config
    ./shared/asahi-shared-drive.nix    # SharedData XDG setup
  ];

  # Any other Asahi-specific home-manager settings
  # (currently nothing needed here, but keeps structure clean)
}

