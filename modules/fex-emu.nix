{ config, pkgs, lib, ... }:
{
  # Enable binfmt for transparent x86_64 emulation
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # Install FEX-Emu
  environment.systemPackages = with pkgs; [
    fex-emu
  ];

  # FEX configuration
  environment.etc."fex-emu/Config.json".text = builtins.toJSON {
    # Enable GPU acceleration for x86 apps
    GPU = {
      DisableGPU = false;
    }; 
  };

  # Override binfmt to use FEX instead of QEMU for x86_64
  # This makes x86_64 binaries run through FEX automatically
  systemd.services."systemd-binfmt".serviceConfig = {
    ExecStart = lib.mkForce [
      ""  # Clear default
      "${pkgs.systemd}/lib/systemd/systemd-binfmt"
    ];
  };

  # Register FEX as x86_64 handler
  boot.binfmt.registrations.x86_64 = {
    interpreter = "${pkgs.fex-emu}/bin/FEXInterpreter";
    magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
    mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    fixBinary = true;
  };

  # Environment variables for FEX
  environment.sessionVariables = {
    FEX_ROOTFS = "/";
    FEX_ENABLECONFIG = "1";
  };
}

