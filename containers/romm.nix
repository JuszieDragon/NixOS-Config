{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.hosts.${config.networking.hostName}.services.romm;
  configDir = "/data/docker/romm";
  dbName = "romm";
  dbUser = "romm-user";

in {
  options.modules.romm = catalog.defaultOptions;

  config = mkIf cfg.enable {
    age.secrets = {
      romm = { file = inputs.self + /secrets/romm.age; };
      romm-db = { file = inputs.self + /secrets/romm-db.age; };
    };

    virtualisation.oci-containers.containers = {
      romm = {
        image = "rommapp/romm:latest";
        ports = [ "${cfg.port}:8080" ];
        environment = {
          DB_HOST = "romm-db";
          DB_NAME = dbName;
          DB_USER = dbUser;
        };
        environmentFiles = [ config.age.secrets.romm.path ];
        volumes = [
          "/mnt/NAS/Files/RomM:/romm/library"
          (configDir + "/resources:/romm/resources")
          (configDir + "/redis_data:/redis_data")
          (configDir + "/assets:/romm/assets")
          (configDir + "/config:/romm/config")
        ];
        dependsOn = [ "romm-db" ];
      };

      romm-db = {
        image = "mariadb:latest";
        environment = {
          MARIADB_USER = dbUser;
          MARIADB_DATABASE = dbName;
        };
        environmentFiles = [ config.age.secrets.romm-db.path ];
        volumes = [ (configDir + "/mysql:/var/lib/mysql") ];
      };
    };
  };
}
