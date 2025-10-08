{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let 
  cfg = catalog.services.openspeedtest;
  hostName = config.networking.hostName;

in {
  options.modules.openspeedtest = catalog.defaultOptions // catalog.subdomainOption;

  config = mkIf (cfg.isEnabled hostName) {
    virtualisation.oci-containers.containers = {
      openspeedtest = {
        image = "openspeedtest/latest";
        ports = [ "${cfg.portString}:3000" ];
      };
    };
  };
}
