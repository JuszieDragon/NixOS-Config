{ catalog, config, inputs, lib, pkgs, ... }:
let
  cfg = catalog.services.paperless;
  stateDir = "/state/paperless";
  mediaDir = "/mnt/media/paperless";
in {
  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    domain = "paperless.${catalog.domain}";
    dataDir = stateDir;
    consumptionDir = mediaDir + "/inbox";
    mediaDir = mediaDir + "/imported";
    inherit (cfg) port;
  };
}
