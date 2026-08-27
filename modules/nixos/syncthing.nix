{ catalog, config, inputs, lib, ... }:
let
  hostname = config.networking.hostName;
  cfg = catalog.services.syncthing;
  secrets = config.age.secrets;
in lib.mkIf cfg.isEnabled {
  age.secrets = {
    gui-password = {
      file = inputs.self + /secrets/syncthing-gui-password.age;
      owner = "justin";
    };
    syncthing-cert = {
      file = inputs.self + /secrets/${hostname}-syncthing-cert.age;
      owner = "justin";
    };
    syncthing-key = {
      file = inputs.self + /secrets/${hostname}-syncthing-key.age;
      owner = "justin";
    };
  };

  services.syncthing = {
    enable = true;
    user = "justin";
    group = "users";
    dataDir = "/home/justin";
    guiAddress = "0.0.0.0:${cfg.portString}";
    guiPasswordFile = secrets.gui-password.path;
    key = secrets.syncthing-key.path;
    cert = secrets.syncthing-cert.path;
    settings = {
      gui.user = "justin";
    };
  };
}
