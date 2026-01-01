{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # ---------- Python ----------
    python3
    python3Packages.virtualenv
    python3Packages.pip-tools
    python3Packages.ipython

    # ---------- C# ----------
    dotnet-sdk

    # ---------- JavaScript / TypeScript ----------
    nodejs_24
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    bun

    # ---------- Rust ----------
    rustup
    cargo-watch
    cargo-expand

    # ---------- Media tools ----------
    ffmpeg

    # ---------- Utilities ----------
    wakeonlan
  ];

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
