{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.sonarr-anime;
  hostName = config.networking.hostName;
  util-nixarr = config.util-nixarr;

in {
  options.modules.sonarr-anime = catalog.defaultOptions;

  config = mkIf (cfg.isEnabled hostName) {
    containers.sonarr-anime = {
      autoStart = true;
      hostAddress = cfg.host.ip;
      bindMounts = {
        "/state" = {
          hostPath = "/state";
          isReadOnly = false;
        };
        "/media/Anime" = {
          hostPath = "/media/Anime";
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
          dataDir = "/state/sonarr-anime";
        };

        system.stateVersion = "24.11";
      };
    };
  };
}
