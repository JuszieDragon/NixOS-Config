{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let cfg = config.modules.openspeedtest;

in {
  options.modules.openspeedtest = catalog.defaultOptions // catalog.subdomainOption;

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      openspeedtest = {
        image = "openspeedtest/latest";
        ports = [ "${cfg.port}:3000" ];
      };
    };
  };
}
