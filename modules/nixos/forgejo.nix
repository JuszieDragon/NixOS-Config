{ catalog, config, inputs, lib, pkgs, ... }:

with lib;

let
  cfg = catalog.services.forgejo;

  stateDir = "/state/forgejo";

in lib.mkIf cfg.isEnabled {
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.example.com";
        ROOT_URL = "https://forgejo.${catalog.domain}";
        HTTP_PORT = cfg.port;
      };
    };
  };
}
