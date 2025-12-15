{ catalog, config, lib, ... }: 

with lib;

let
  cfg = catalog.services.yamtrack;
  configDir = "/state/yamtrack";
  id = 1936;
  idStr = toString id;

in {
  users = {
    groups.yamtrack.gid = id;
    users.yamtrack = {
      isSystemUser = true;
      uid = id;
      group = "yamtrack";
    };
  };
        
  virtualisation.oci-containers.containers = mkIf cfg.isEnabled {
    yamtrack = {
      image = "ghcr.io/fuzzygrim/yamtrack:0.24.9";
      ports = [ "${cfg.portString}:8000" ];
      environment = {
        PUID = "${idStr}";
        PGID = "${idStr}";
        REDIS_URL = "redis://yamtrack-redis:6379";
        URLS = "https://yamtrack.dragon.luxe";
        ADMIN_ENABLED = "True";
        TZ = "Australia/Hobart";
      };
      dependsOn = [ "yamtrack-redis" ];
      volumes = [ (configDir + "/core:/yamtrack/db") ];
    };

    yamtrack-redis = {
      image = "redis:8-alpine";
      user = "${idStr}:${idStr}";
      volumes = [ (configDir + "/redis:/data") ];
    };
  };
}

