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

  # macOS-specific additional aliases
  programs.zsh.shellAliases = {
    # macOS system shortcuts
    showfiles = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
    
    # Quick access
    icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";
  };
}

