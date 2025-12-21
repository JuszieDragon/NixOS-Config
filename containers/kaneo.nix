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

    #TODO at least pretend to care about security
    AUTH_SECRET = "d3353680-29a2-4e1b-b134-8eb1a421d74e";
  };
  id = 1825;
  idStr = toString id;
  version = "2.1.6";

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
      user = "${idStr}:${idStr}";
      environment = env;
      volumes = [ (configDir + ":/var/lib/postgresql/data") ];
    };
  };
}

