{ config, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.komga;
  hostName = config.networking.hostName;

in {
  options.modules.komga = catalog.defaultOptions;

  config = mkIf (cfg.isEnabled hostName) {
    services.komga = {
      enable = true;
      settings.server.port = cfg.port;
      stateDir = "/state/komga";
      group = "media";
    };
  };
}
