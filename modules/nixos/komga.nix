{ config, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.komga;
  hostName = config.networking.hostName;

in {
  services.komga = {
    enable = cfg.isEnabled hostName;
    settings.server.port = cfg.port;
    stateDir = "/state/komga";
    group = "media";
  }; 
}

