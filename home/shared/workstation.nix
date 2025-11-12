{ config, pkgs, lib, ... }:
{
  # Packages that work on BOTH macOS and Linux
  home.packages = with pkgs; [
    # === Development GUIs ===
    vscodium
    
    # === Media & Creative ===
    # Audio production
    audacity
    musescore
    # (blender, krita via system-specific - see below)
    
    # === Communication ===
    vesktop  # Discord client
    
    # === Utilities ===
    ollama  # AI/LLM
    
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific GUI apps
    firefox
    chromium
    gimp
    inkscape
    blender
    krita
    vlc
    libreoffice
    
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific utilities
    mkalias  # For app aliasing
  ];

  # Shared aliases for workstation use
  programs.zsh.shellAliases = {
    # Development shortcuts
    code = "codium";  # VSCodium
    v = "nvim";
    vi = "nvim";
    
    # Common operations
    update-home = "home-manager switch --flake ~/dotfiles";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # macOS-specific aliases
    update = "darwin-rebuild switch --flake ~/dotfiles";
    wake-server = "wakeonlan XX:XX:XX:XX:XX:XX";
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    # Linux-specific aliases
    update = "sudo nixos-rebuild switch --flake ~/dotfiles#linux-laptop";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
  };

  # Git config for workstation
  programs.git.extraConfig = {
    # Workstation-specific git settings
    credential.helper = if pkgs.stdenv.isDarwin 
      then "osxkeychain" 
      else "libsecret";
  };
}

