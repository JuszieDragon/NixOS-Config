{ catalog, config, lib, ... }:
let
  cfg = catalog.services.librespeed;

in {
  services.librespeed = {
    enable = true;
    frontend = lib.mkIf (config.networking.hostName == cfg.frontendHost) {
      enable = true;
      contactEmail = "";
      servers = map (host: {
        name = host;
        server = "//${catalog.hosts.${host}.ip}:${cfg.portString}";
      }) cfg.hosts;
    };
    settings = {
      bind_address = "0.0.0.0";
      listen_port = cfg.port;
    };
  };
}
