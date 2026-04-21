{ catalog, config, inputs, lib, pkgs, ... }:

with lib;

let
  cfg = catalog.services.forgejo;

  stateDir = "/state/forgejo";

in lib.mkIf cfg.isEnabled {
  age.secrets.forgejo-admin-password = {
    file = inputs.self + /secrets/forgejo-admin-password.age;
    owner = "forgejo";
  };

  services.forgejo = {
    enable = true;
    lfs.enable = true;
    inherit stateDir;
    settings = {
      server = {
        DOMAIN = "git.example.com";
        ROOT_URL = "https://forgejo.${catalog.domain}";
        HTTP_PORT = cfg.port;
      };
    };
  };

  systemd.services.forgejo.preStart = let 
    adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
    pwd = config.age.secrets.forgejo-admin-password;
    user = "justin"; # Note, Forgejo doesn't allow creation of an account named "admin"
  in ''
    ${adminCmd} create --admin --email "jusziedragon@gmail.com" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    ## uncomment this line to change an admin user which was already created
    # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
  '';
}
