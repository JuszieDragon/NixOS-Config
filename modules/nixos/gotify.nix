{ catalog, config, inputs, lib, pkgs, ... } :
let
  cfg = catalog.services.gotify;
  stateDir = "/state/gotify";
  id = 9802;
in {
  users = lib.mkIf cfg.isEnabled {
    users.gotify = {
      uid = id;
      group = "gotify";
      isSystemUser = true;
    };
    groups.gotify.gid = id;
  };

  services.gotify = {
    inherit (cfg) enable;
    environment.GOTIFY_SERVER_PORT = cfg.port;
  };

  systemd = lib.mkIf cfg.isEnabled {
    services.gotify-server.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "gotify";
      Group = "gotify";
      WorkingDirectory = lib.mkForce stateDir;
      StateDirectory = lib.mkForce stateDir;
    };
    tmpfiles.settings.gotify-server.${stateDir}.d =  {
      user = "gotify";
      group = "gotify";
      mode = "0775";
    };
  };
}
