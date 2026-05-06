{ catalog, lib, ... }:

let
  cfg = catalog.services.kosync;
  stateDir = "/state/kosync";
  id = 9362;

in {
  users = lib.mkIf cfg.isEnabled {
    users.kosync.uid = id;
    groups.kosync.gid = id;
  };

  systemd.tmpfiles.settings.kosync.${stateDir}.d = {
    user = "kosync";
    group = "kosync";
    mode = "0775";
  };

  services.kosync = {
    enable = true;
    inherit (cfg) port;
    dbPath = stateDir + "/kosync.db";
  };
}
