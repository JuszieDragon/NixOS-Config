{ catalog, config, lib, ... }:

with lib;

let
  cfg = catalog.services.kaneo;
  configDir = "/state/kaneo";
  env = {
    KANEO_CLIENT_URL = "http://localhost:${cfg.portString}";
    KANEO_API_URL = "http://localhost:1337";

    DATABASE_URL = "postgresql://kaneo:Qywter101@kaneo-db:5432/kaneo";
    POSTGRES_DB = "kaneo";
    POSTGRES_USER = "kaneo";
    POSTGRES_PASSWORD = "Qywter101";

    CORS_ORIGINS="http://localhost:${cfg.portString}";
  };
  id = 1825;
  idStr = toString id;
  version = "2.0.3";

in {
  users = {
    groups.kaneo.gid = id;
    users.kaneo = {
      isSystemUser = true;
      uid = id;
      group = "kaneo";
    };
  };

  virtualisation.oci-containers.containers = mkIf cfg.isEnabled {
    kaneo-web = {
      image = "ghcr.io/usekaneo/web:${version}";
      ports = [ "${cfg.portString}:5173" ];
      environment = env;
      dependsOn = [ "kaneo-api" ];
    };

    kaneo-api = {
      image = "ghcr.io/usekaneo/api:${version}";
      ports = [ "1337:1337" ];
      environment = env;
      dependsOn = [ "kaneo-db" ];
    };

    kaneo-db = {
      image = "postgres:16-alpine";
      ports = [ "5432:5432" ];
      environment = env // { REDIS_ARGS = "--user ${idStr}:${idStr}"; };
      volumes = [ (configDir + ":/var/lib/postgresql/data") ];
    };
  };
}

