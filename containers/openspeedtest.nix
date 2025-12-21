{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.openspeedtest;

in {
  virtualisation.oci-containers.containers = {
    openspeedtest = mkIf cfg.isEnabled {
      image = "openspeedtest/latest:v2.0.6";
      ports = [ "${cfg.portString}:3000" ];
    };
  };
}

