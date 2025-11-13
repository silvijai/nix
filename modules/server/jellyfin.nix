{ config, pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "MAID0";
    dataDir = "/var/lib/jellyfin/";
  };

  # Optional: reverse proxy with nginx
  # services.nginx.virtualHosts."jellyfin.example.com" = { ... };
}
