{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

with lib;

let 
  cfg = config.modules.romm;
  configDir = "/data/docker/romm";
  dbName = "romm";
  dbUser = "romm-user";

in {
  options.modules.romm.enable = mkEnableOption "Run RomM";

  config = mkIf cfg.enable {
    #users = {
    #  users.romm = {
    #    isSystemUser = true;
    #    group = "romm";
    #  };

    #  groups.romm = {};
    #};

    age.secrets = {
      romm = {
        file = inputs.self + /secrets/romm.age;
      };

      romm-db = {
        file = inputs.self + /secrets/romm-db.age;
      };
    };

    virtualisation.oci-containers.containers = {
      romm = {
        image = "rommapp/romm:latest";
	ports = ["8282:8080"];
	environment = {
          DB_HOST = "romm-db";
	  DB_NAME = dbName;
	  DB_USER = dbUser;
	};
	environmentFiles = [config.age.secrets.romm.path];
        volumes = [ 
	  "/mnt/NAS/Files/RomM:/romm/library"
	  (configDir + "/resources:/romm/resources")
	  (configDir + "/redis_data:/redis_data")
	  (configDir + "/assets:/romm/assets")
	  (configDir + "/config:/romm/config")
	];
	dependsOn = ["romm-db"];
      };
    
      romm-db = {
        image = "mariadb:latest";
	environment = {
          MARIADB_USER = dbUser;
	  MARIADB_DATABASE = dbName;
	};
	environmentFiles = [config.age.secrets.romm-db.path];
	volumes = [(configDir + "/mysql:/var/lib/mysql")];
      };
    };
  };
}
