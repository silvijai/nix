{ config, pkgs, lib, ... }:
{
  # Enable binfmt for x86_64 emulation (uses FEX automatically on ARM)
  boot.binfmt.emulatedSystems = [ 
    "x86_64-linux"
    "i686-linux"
  ];

  # FEX is provided by the system, not as a package
  # The Asahi kernel + binfmt handles x86 emulation automatically
  
  # Environment variables for better FEX performance
  environment.sessionVariables = {
    FEX_ROOTFS = "/";
    FEX_ENABLECONFIG = "1";
  };
}

