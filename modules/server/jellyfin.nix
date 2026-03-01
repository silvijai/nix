{
  config,
  pkgs,
  ...
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/data/media";
  };

  # Optional: reverse proxy with nginx
  # services.nginx.virtualHosts."jellyfin.example.com" = { ... };
}
