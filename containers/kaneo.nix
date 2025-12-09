{ catalog, config, lib, ... }:

with lib;

let
  cfg = catalog.services.kaneo;
  configDir = "/state/kaneo";
  env = rec {
    KANEO_CLIENT_URL = "https://kaneo.dragon.luxe";
    KANEO_API_URL = "https://kaneo-api.dragon.luxe";

    DATABASE_URL = "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@kaneo-db:5432/kaneo";
    POSTGRES_DB = "kaneo";
    POSTGRES_USER = "kaneo";
    POSTGRES_PASSWORD = "Qywter101";

    CORS_ORIGINS="${KANEO_CLIENT_URL}";
  };
  id = 1825;
  idStr = toString id;
  version = "2.0.4";

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

