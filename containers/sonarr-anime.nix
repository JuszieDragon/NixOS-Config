{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.sonarr-anime;
  util-nixarr = config.util-nixarr;

in {
  options.modules.sonarr-anime = catalog.defaultOptions;

  config = mkIf cfg.enable {
    containers.sonarr-anime = {
      autoStart = true;
      hostAddress = cfg.host.ip;
      bindMounts = {
        "/data" = {
          hostPath = "/data";
          isReadOnly = false;
        };
        "/mnt/Plex/Anime" = {
          hostPath = "/mnt/Plex/Anime";
          isReadOnly = false;
        };
      };

      config = { config, pkgs, lib, ... }: {
        users = {
          groups.media.gid = util-nixarr.globals.gids.media;
          users.sonarr = {
            isSystemUser = true;
            uid = util-nixarr.globals.uids.sonarr;
            group = "media";
          };
        };
        
        services.sonarr = {
          enable = true;
          user = "sonarr";
          group = "media";
          settings.server.port = cfg.port;
          dataDir = "/data/media/.state/sonarr-anime";
        };

        system.stateVersion = "24.11";
      };
    };
  };
}