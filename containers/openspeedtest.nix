{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let cfg = catalog.hosts.${config.networking.hostName}.services.openspeedtest;

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
