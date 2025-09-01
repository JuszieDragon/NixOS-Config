{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let cfg = catalog.services.sonarr-anime;

in {
  options.modules.sonarr-anime = catalog.defaultOptions;

  config = mkIf cfg.enable {
    containers.sonarr-anime = {
      autoStart = true;
      hostAddress = cfg.host.ip;
      bindMounts = {
        "/data/media/.state/sonarr-anime" = {
          hostPath = "/data/media/.state/sonarr-anime";
          isReadOnly = false;
        };
      };

      config = { config, pkgs, lib, ... }: {
        services.sonarr = {
          enable = true;
          settings.server.port = cfg.port;
          dataDir = "/data/media/.state/sonarr-anime";
        };

        system.stateVersion = "24.11";
      };
    };
  };
}