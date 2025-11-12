{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Python
    python3
    virtualenv

    # C#
    dotnet-sdk

    # JavaScript/TypeScript
    nodejs_24
    corepack
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server

    # Rust
    rustup

    # Media tools
    ffmpeg

    # Utilities
    wakeonlan
  ];

  # Development aliases
  programs.zsh.shellAliases = {
    # Git shortcuts
    gs = "git status";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gco = "git checkout";
    
    # Development
    py = "python3";
    serve = "python3 -m http.server";
  };
}
