{ catalog, lib, ... }:

let
  cfg = catalog.services.kavita;
  configDir = "/state/kavita";
  uid = 4037;

in lib.mkIf cfg.isEnabled {
  users.users.kavita.uid = uid;

  services.kavita = {
    enable = true;
    user = "kavita";
    group = "media";
    dataDir = configDir;
    settings = {
      Port = cfg.port;
    };
  };

  systemd.tmpfiles.rules = [ "d ${configDir} 0755 kavita media - " ];
}
