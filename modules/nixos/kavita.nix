{ catalog, config, inputs, lib, ... }:
let
  cfg = catalog.services.kavita;
  configDir = "/state/kavita";

in lib.mkIf cfg.isEnabled {
  users.users.kavita.uid = 8367;

  age.secrets.kavita.file = inputs.self + /secrets/kavita.age;

  services.kavita = {
    enable = true;
    dataDir = configDir;
    group = "media";
    tokenKeyFile = config.age.secrets.kavita.path;
    settings.Port = cfg.port;
  };
}
