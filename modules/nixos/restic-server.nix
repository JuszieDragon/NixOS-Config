{ catalog, config, lib, inputs, ... }:
let
  cfg = catalog.services.restic-server;

  dataDir = "/mnt/backup/restic";

in lib.mkIf cfg.enable {
  age.secrets.restic-server = {
    file = inputs.self + /secrets/restic-server-password.age;
    owner = "restic";
    group = "restic";
    mode = "0400";
  };

  services.restic.server = {
    enable = cfg.isEnabled;
    inherit dataDir;
    listenAddress = cfg.portString;
    htpasswd-file = config.age.secrets.restic-server.path;
    prometheus = true;
  };
}
