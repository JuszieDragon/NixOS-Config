{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.openspeedtest;
  hostName = config.networking.hostName;

in {
  virtualisation.oci-containers.containers = {
    openspeedtest = mkIf (cfg.isEnabled hostName) {
      image = "openspeedtest/latest";
      ports = [ "${cfg.portString}:3000" ];
    };
  };
}

