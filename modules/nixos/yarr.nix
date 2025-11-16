{ catalog, config, lib, inputs, ... }: 

with lib;

let
  cfg = catalog.services.yarr;
  hostName = config.networking.hostName;

in {
  age.secrets.yarr.file = inputs.self + /secrets/yarr.age;

  services.yarr = {
    enable = cfg.isEnabled hostName;
    port = cfg.port;
    address = "0.0.0.0";
    dbPath = "/state/yarr/storage.db";
    authFilePath = config.age.secrets.yarr.path;
  };
}

