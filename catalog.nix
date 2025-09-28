{ lib, ... }:

with lib;

rec {
  domain = "dragon.luxe";
  
  defaultOptions = {
    enable = mkEnableOption "Run service";
    port = mkOption {
      type = types.str;
      description = "Port to run service on";
    };
    #TODO the type isn't evaluated unless the option is used in the module file, need to manually check this myself
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
  
  hostsBase = {
    night-city = {
      isNixos = true;
      ip = "192.168.1.100";
    };

    truenas = {
      isNixos = false;
      ip = "192.168.1.1";
    };

    home-assistant = {
      isNixos = false;
      ip = "192.168.1.3";
    };

    revachol = {
      isNixos = false;
      ip = "192.168.2.1";
    };

    tracen = {
      isNixos = false;
      ip = "192.168.2.5";
    };

    cabin = {
      isNixos = false;
      ip = "192.168.2.7";
    };
  };

  hosts = mapAttrs (host: attrs:
    attrs // { hostName = host; }
  ) hostsBase;

  servicesBase = {
    jellyfin = {
      enable = true;
      host = hosts.night-city;
      port = 8096;
      reverseProxy = "external";
    };
    radarr = {
      enable = true;
      host = hosts.night-city;
      port = 7878;
      reverseProxy = "internal";
    };
    sonarr = {
      enable = true;
      host = hosts.night-city;
      port = 8989;
      reverseProxy = "internal";
    };
    sonarr-anime = {
      enable = true;
      host = hosts.night-city;
      port = 8990;
      reverseProxy = "internal";
    };
    prowlarr = {
      enable = true;
      host = hosts.night-city;
      port = 9696;
      reverseProxy = "internal";
    };
    transmission = {
      enable = true;
      host = hosts.night-city;
      port = 9092;
      reverseProxy = "internal";
    };
    tt-rss = {
      enable = true;
      host = hosts.night-city;
      reverseProxy = "none";
    };
    openspeedtest = {
      enable = true;
      host = hosts.night-city;
      port = 3000;
      reverseProxy = "internal";
      subdomain = "speedtest";
    };
    romm = {
      enable = true;
      host = hosts.night-city;
      port = 8282;
      reverseProxy = "internal";
    };
    caddy = {
      enable = true;
      host = hosts.night-city;
    };
    qbittorrent = {
      enable = true;
      host = hosts.night-city;
      port = 8081;
      reverseProxy = "internal";
    };
    komga = {
      enable = true;
      host = hosts.night-city;
      port = 8082;
      reverseProxy = "internal";
    };

    truenas = {
      enable = true;
      host = hosts.truenas;
      reverseProxy = "internal";
    };

    home-assistant = {
      enable = true;
      host = hosts.home-assistant;
      port = 8123;
      reverseProxy = "internal";
    };

    revachol-syncthing = {
      enable = true;
      host = hosts.revachol;
      port = 8384;
      reverseProxy = "internal";
      nameOverride = "syncthing";
    };

    tracen-syncthing = {
      enable = true;
      host = hosts.tracen;
      port = 8082;
      reverseProxy = "internal";
      nameOverride = "syncthing";
    };

    cabin-syncthing = {
      enable = true;
      host = hosts.cabin;
      port = 8384;
      reverseProxy = "internal";
      nameOverride = "syncthing";
    };
  };

  #TODO setup container seperately maybe
  containers = {};

  services = mapAttrs (service: attrs:
    attrs // { portString = if attrs ? port
      then builtins.toString attrs.port
      else ""; 
    }
  ) servicesBase;

  #test = trace (builtins.toJSON services) services;
}