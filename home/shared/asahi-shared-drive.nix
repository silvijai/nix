{ config, lib, ... }:
{
  # XDG user directories pointing to SharedData
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;  # Folders already exist on SharedData
      
      # Keep Desktop local (better for Wayland/Hyprland)
      desktop = "${config.home.homeDirectory}/Desktop";
      
      # Point to SharedData
      documents = "/mnt/Shared/Documents";
      download = "/mnt/Shared/Downloads";
      music = "/mnt/Shared/Music";
      pictures = "/mnt/Shared/Pictures";
      videos = "/mnt/Shared/Movies";
      
      # Keep these local
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
    };
  };

  # SharedData-specific aliases
  programs.zsh.shellAliases = {
    shared = "cd /mnt/Shared";
    
    # Quick access to macOS home (if you want to access macOS files from NixOS)
    macos = "cd /mnt/macos-home/silvija";
  };

  # Optional: Create activation script to verify SharedData is mounted
  home.activation.checkSharedData = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "/mnt/Shared" ]; then
      echo "⚠️  Warning: SharedData not mounted at /mnt/Shared"
      echo "   Run: sudo mount /dev/disk/by-label/shared /mnt/Shared"
    else
      echo "✓ SharedData mounted"
    fi
  '';
}

