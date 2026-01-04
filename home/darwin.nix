{
  config,
  pkgs,
  inputs,
  ...
}: let
  lib = pkgs.lib;
in {
  imports = [
    ./common.nix
    ./shared/development.nix
    ./shared/workstation.nix
    ../modules/sway-vm.nix
    ../modules/sway-vm-safe.nix
  ];

  # User info
  home.username = "silvija";
  home.homeDirectory = lib.mkForce "/Users/silvija";

  # macOS-ONLY packages (things from Homebrew casks that need macOS)
  home.packages = with pkgs; [
    # macOS-specific development tools
    docker-client # Docker Desktop on macOS

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

      # Create reverse symlink: SharedData/nix -> ~/nix
      # This allows accessing your nix config from SharedData
      if [ -d "$HOME/nix" ] && [ ! -e "$SHARED_PATH/nix" ]; then
        echo "  ✓ Creating SharedData/nix → ~/nix symlink"
        $DRY_RUN_CMD ln -sfn "$HOME/nix" "$SHARED_PATH/nix"
      elif [ -L "$SHARED_PATH/nix" ] && [ "$(readlink "$SHARED_PATH/nix")" = "$HOME/nix" ]; then
        echo "  ✓ SharedData/nix symlink already exists"
      elif [ -e "$SHARED_PATH/nix" ] && [ ! -L "$SHARED_PATH/nix" ]; then
        echo "  ⚠ /Volumes/shared/nix exists but is not a symlink"
        echo "    Move it back: mv /Volumes/shared/nix ~/nix && ln -s ~/nix /Volumes/shared/nix"
      fi
    else
      echo "⚠ SharedData not mounted at $SHARED_PATH"
    fi
  '';

  # Ensure the directory exists and place the file
  xdg.configFile."karabiner/assets/complex_modifications/hyper_f20.json".text = ''
    {
      "title": "Caps Lock: Hyper (hold), F20 (tap), Normal Caps (Fn+tap)",
      "rules": [
        {
          "description": "Caps Lock Behavior Logic",
          "manipulators": [
            {
              "description": "Fn + Caps Lock -> Standard Caps Lock (Toggle Fix)",
              "from": {
                "key_code": "caps_lock",
                "modifiers": { "mandatory": ["fn"], "optional": ["any"] }
              },
              "to": [{ "key_code": "caps_lock" }],
              "type": "basic"
            },
            {
              "description": "Caps Lock -> Hyper Key (Hold) / F20 (Tap)",
              "from": {
                "key_code": "caps_lock",
                "modifiers": { "optional": ["any"] }
              },
              "to": [
                {
                  "key_code": "left_shift",
                  "modifiers": ["left_command", "left_control", "left_option"]
                }
              ],
              "to_if_alone": [{ "key_code": "f20" }],
              "type": "basic"
            }
          ]
        }
      ]
    }
  '';

  # macOS-specific additional aliases
  programs.zsh.shellAliases = {
  };

  # Completely disable HM app management on macOS
  home.activation = {
    # Skip the permission check
    checkAppManagementPermission = lib.mkForce (config.lib.dag.entryAfter ["writeBoundary"] ''
      echo "Skipping macOS App Management (disabled)"
    '');

    # Skip the actual app copying/updating
    copyApps = lib.mkForce (config.lib.dag.entryAfter ["writeBoundary"] ''
      echo "Skipping Home Manager Apps copy (disabled)"
    '');

    # Skip symlink creation to ~/Applications/Home Manager Apps
    symlinkApps = lib.mkForce (config.lib.dag.entryAfter ["writeBoundary"] ''
      echo "Skipping Home Manager Apps symlinks (disabled)"
    '');
  };
}
