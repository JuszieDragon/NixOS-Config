{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.sonarr-anime;
  util-nixarr = config.util-nixarr;

in {
  containers.sonarr-anime = mkIf cfg.isEnabled {
    autoStart = true;
    hostAddress = cfg.host.ip;
    bindMounts = {
      "/state" = {
        hostPath = "/state";
        isReadOnly = false;
      };
      "/mnt/media" = {
        hostPath = "/mnt/media";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, lib, ... }: {
      users = {
        #If have issue with media having wrong guid again use this https://superuser.com/questions/1736609
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

  #make container wait for the network to be fully up before starting to prevent networking issues
  #https://discourse.nixos.org/t/dns-in-declarative-container/1529/5
  systemd.services."container@sonarr-anime" = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}

