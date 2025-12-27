{ config, pkgs, inputs, ... }: 
let
  lib = pkgs.lib;
in {
  imports = [
    ./common.nix
    ./shared/development.nix
    ./shared/workstation.nix     # ← Shared GUI apps
  ];

  # User info
  home.username = "silvija";
  home.homeDirectory = lib.mkForce "/Users/silvija";

  # macOS-ONLY packages (things from Homebrew casks that need macOS)
  home.packages = with pkgs; [
    # macOS-specific development tools
    jetbrains-mono
    docker-client  # Docker Desktop on macOS
    
    # Note: Many GUI apps installed via Homebrew in darwin/configuration.nix
    # because they're better maintained as casks
  ];

  # Setup SharedData symlinks via home-manager activation
  home.activation.linkSharedFolders = config.lib.dag.entryAfter ["writeBoundary"] ''
    SHARED_PATH="/Volumes/shared"
    
    if [ -d "$SHARED_PATH" ]; then
      # Function to ensure symlink exists
      ensure_symlink() {
        local folder_name="$1"
        
        # If already correctly symlinked, skip
        if [ -L "$HOME/$folder_name" ] && [ "$(readlink "$HOME/$folder_name")" = "$SHARED_PATH/$folder_name" ]; then
          echo "  ✓ $folder_name already linked"
          return
        fi
        
        # If it's a directory (not symlink), warn user to migrate manually
        if [ -d "$HOME/$folder_name" ] && [ ! -L "$HOME/$folder_name" ]; then
          echo "  ⚠ $folder_name is not a symlink - please migrate manually"
          echo "    Run: mv ~/$folder_name ~/$folder_name.backup && ln -s $SHARED_PATH/$folder_name ~/$folder_name"
          return
        fi
        
        # If broken symlink or doesn't exist, create it
        if [ -L "$HOME/$folder_name" ] || [ ! -e "$HOME/$folder_name" ]; then
          $DRY_RUN_CMD rm -f "$HOME/$folder_name"
          $DRY_RUN_CMD mkdir -p "$SHARED_PATH/$folder_name"
          $DRY_RUN_CMD ln -sfn "$SHARED_PATH/$folder_name" "$HOME/$folder_name"
          echo "  ✓ Created symlink for $folder_name"
        fi
      }
      
      # Ensure symlinks exist
      ensure_symlink "Downloads"
      ensure_symlink "Documents"
      ensure_symlink "Music"
      ensure_symlink "Pictures"
      ensure_symlink "Movies"
    else
      echo "⚠ SharedData not mounted at $SHARED_PATH"
    fi
  '';

  # macOS-specific additional aliases
  programs.zsh.shellAliases = {
    # macOS system shortcuts
    showfiles = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
    
    # Quick access
    icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";
  };
}

