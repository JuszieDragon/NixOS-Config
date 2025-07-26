{ config, inputs, pkgs, lib, ... }:

with lib;

let cfg = config.modules.openspeedtest;

in {
  options.modules.openspeedtest = {
    enable = mkEnableOption "Run OpenSpeedTest";
    port = mkOption {
      type = types.str;
      description = "Port to run service on";
    };
    reverseProxy = mkOption {
      type = types.enum [ "internal" "external" ];
      description = "Reverse proxy type, valid options are internal and external";
    };
    subdomain = mkOption {
      type = types.str;
      description = "Override for the subdomain name in the reverse proxy";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      openspeedtest = {
        image = "openspeedtest/latest";
        ports = [ "${cfg.port}:3000" ];
      };
    };
  };
}
