{ catalog, config, lib, inputs, ... }: 

with lib;

let
  cfg = catalog.services.yarr;
  hostName = config.networking.hostName;

in {
  options.modules.yarr = catalog.defaultOptions;

  config = mkIf (cfg.isEnabled hostName) {
    age.secrets.yarr.file = inputs.self + /secrets/yarr.age;

    services.yarr = {
      enable = true;
      port = 7070;
      address = "0.0.0.0";
      dbPath = "/state/yarr/storage.db";
      authFilePath = config.age.secrets.yarr.path;
    };
  };
}
