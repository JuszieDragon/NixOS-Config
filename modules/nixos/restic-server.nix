{ catalog, lib, ... }:

with lib;

let
  cfg = catalog.services.restic-server;

  dataDir = "/mnt/backup/restic";

in {
  services.restic.server = {
    enable = cfg.isEnabled;
    extraFlags = [ "--no-auth" ];
    inherit dataDir;
    listenAddress = cfg.portString;
    prometheus = true;
  };
}
