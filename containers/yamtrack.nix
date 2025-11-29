{ catalog, config, lib, ... }: 

with lib;

let
  cfg = catalog.services.yamtrack;
  hostName = config.networking.hostName;
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
        
  virtualisation.oci-containers.containers = mkIf (cfg.isEnabled hostName) {
    yamtrack = {
      image = "ghcr.io/fuzzygrim/yamtrack:0.24.8";
      ports = [ "${cfg.portString}:8000" ];
      environment = {
        PUID = "${idStr}";
        PGID = "${idStr}";
        REDIS_URL = "redis://yamtrack-redis:6379";
        TZ = "Australia/Hobart";
      };
      dependsOn = [ "yamtrack-redis" ];
      volumes = [ (configDir + "/core:/yamtrack.db") ];
    };

    yamtrack-redis = {
      image = "redis:8-alpine";
      environment = { REDIS_ARGS = "--user ${idStr}:${idStr}"; };
      volumes = [ (configDir + "/redis:/data") ];
    };
  };
}
