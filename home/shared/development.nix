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

    # Media tools (useful for dev work)
    ffmpeg

    # Utilities
    wakeonlan
  ];

  # Development-focused shell aliases
  programs.zsh.shellAliases = {
    # Enhanced ls with eza
    ls = "eza --group-directories-first --icons --classify";
    ll = "eza -l --group-directories-first --icons --classify --git";
    la = "eza -la --group-directories-first --icons --classify --git";
    lt = "eza -l --tree --level=2 --group-directories-first --icons";
    
    # Git shortcuts
    gs = "git status";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gco = "git checkout";
    
    # Development
    py = "python3";
    ipy = "ipython";
    serve = "python3 -m http.server";
  };
}

