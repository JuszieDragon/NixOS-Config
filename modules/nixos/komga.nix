{ config, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.komga;

in {
  services.komga = {
    enable = cfg.isEnabled;
    settings.server.port = cfg.port;
    stateDir = "/state/komga";
    group = "media";
  }; 
}

