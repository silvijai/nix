{ config, pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/jellyfin/";
  };

  # Optional: reverse proxy with nginx
  # services.nginx.virtualHosts."jellyfin.example.com" = { ... };
}
