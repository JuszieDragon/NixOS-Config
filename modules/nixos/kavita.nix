{
  catalog,
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = catalog.services.kavita;
  configDir = "/state/kavita";

in
lib.mkIf cfg.isEnabled {
  users.users.kavita = {
    uid = 8367;
    group = lib.mkForce "media";
  };

  age.secrets.kavita = {
    file = inputs.self + /secrets/kavita.age;
    owner = "kavita";
    group = "media";
    mode = "0400";
  };

  services.kavita = {
    enable = true;
    dataDir = configDir;
    credentials = {
      token_key = config.age.secrets.kavita.path;
    };
    settings = {
      Port = cfg.port;
    };
  };
}
