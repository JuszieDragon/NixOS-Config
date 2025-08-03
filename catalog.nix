{ lib, ... }:

with lib;

{
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

  hosts = { 
    night-city = {
      isNixos = true;
      ip = "192.168.1.100";

      services = {
        jellyfin = {
          enable = true;
          port = "8096";
          reverseProxy = "external";
        };
        radarr = {
          enable = true;
          port = "7878";
          reverseProxy = "internal";
        };
        sonarr = {
          enable = true;
          port = "8989";
          reverseProxy = "internal";
        };
        prowlarr = {
          enable = true;
          port = "9696";
          reverseProxy = "internal";
        };
        transmission = {
          enable = true;
          port = "9092";
          reverseProxy = "internal";
        };

        tt-rss = {
          enable = true;
          reverseProxy = "none";
        };

        openspeedtest = {
          enable = true;
          port = "3000";
          reverseProxy = "internal";
          subdomain = "speedtest";
        };
        romm = {
          enable = true;
          port = "8282";
          reverseProxy = "external";
        };
      };
    };

    truenas = {
      isNixos = false;
      ip = "192.168.1.1";

      services = {
        truenas = {
          enable = true;
          reverseProxy = "internal";
        };
      };
    };

    home-assistant = {
      isNixos = false;
      ip = "192.168.1.3";

      services = {
        home-assistant = {
          enable = true;
          port = "8123";
          reverseProxy = "internal";
        };
      };
    };
  };
}