{ catalog, config, inputs, lib, ... }:
let
  cfg = catalog.services.radicale;
  stateDir = "/state/radicale";
in lib.mkIf cfg.isEnabled {
  age.secrets.radicale = {
    file = inputs.self + /secrets/radicale.age;
    owner = "radicale";
  };

  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "0.0.0.0:${cfg.portString}" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets.radicale.path;
        htpasswd_encryption = "plain";
      };
      storage.filesystem_folder = stateDir;
    };
  };

  systemd.tmpfiles.settings.radicale.${stateDir}.d = {
    user = "radicale";
    group = "radicale";
    mode = "0775";
  };
}
