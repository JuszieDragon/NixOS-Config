{ lib, ... }:

with lib;

let 

in {
  domain = "dragon.luxe";
  
  defaultOptions = {
    enable = mkEnableOption "Run service";
    port = mkOption {
      type = types.str;
      description = "Port to run service on";
    };
    reverseProxy = mkOption {
      type = types.enum [ "internal" "external" "none" ];
      description = "Reverse proxy type, valid options are internal, external and none";
    };
  };

  subdomainOption = {
    subdomain = mkOption {
      type = types.str;
      description = "Override for the subdomain name in the reverse proxy";
      default = null;
    };
  };
}