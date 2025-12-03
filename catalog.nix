{ lib, host, ... }:

with lib;

rec {
  domain = "dragon.luxe";
  
  /*
    options:
      host:
        isNixos: is the host nixos or not? not used atm
        ip: IP address to the host
      services:
        enable: if the service is enabled or not
        host: Which host to run the service on TODO add multihost support
        port: Which port to bind the service to
        reverseProxy: What type of reverse proxy to use, options are: internal, external and none #TODO add local DNS server to handle internal instead of caddy
        subdomain: Override the name used by the reverse proxy
  */

  hostsBase = {
    night-city = {
      isNixos = true;
      ip = "192.168.1.100";
    };

    soul-matrix = {
      isNixos = true;
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
      host = hosts.soul-matrix;
      port = 8096;
      reverseProxy = "external";
    };
    radarr = {
      enable = true;
      host = hosts.soul-matrix;
      port = 7878;
      reverseProxy = "internal";
    };
    sonarr = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8989;
      reverseProxy = "internal";
    };
    sonarr-anime = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8990;
      reverseProxy = "internal";
    };
    prowlarr = {
      enable = true;
      host = hosts.soul-matrix;
      port = 9696;
      reverseProxy = "internal";
    };
    qbittorrent = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8081;
      reverseProxy = "internal";
    };
    komga = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8082;
      reverseProxy = "internal";
    };
    yamtrack = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8084;
      reverseProxy = "internal";
    };
    yarr = {
      enable = true;
      host = hosts.soul-matrix;
      port = 7070;
      reverseProxy = "external";
    };
    scrutiny = {
      enable = true;
      host = hosts.soul-matrix;
      port = 8083;
      reverseProxy = "internal";
    };
    kaneo = {
      enable = true;
      host = hosts.soul-matrix;
      port = 5173;
      reverseProxy = "internal";
    };

    openspeedtest = {
      enable = true;
      host = hosts.night-city;
      port = 3000;
      reverseProxy = "internal";
      subdomain = "speedtest";
    };
    romm = {
      enable = false;
      host = hosts.night-city;
      port = 8282;
      reverseProxy = "internal";
    };
    caddy = {
      enable = true;
      host = hosts.night-city;
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
      subdomain = "syncthing";
    };

    tracen-syncthing = {
      enable = true;
      host = hosts.tracen;
      port = 8082;
      reverseProxy = "internal";
      subdomain = "syncthing";
    };

    cabin-syncthing = {
      enable = true;
      host = hosts.cabin;
      port = 8384;
      reverseProxy = "internal";
      subdomain = "syncthing";
    };
  };

  #TODO setup container seperately maybe
  containers = {};

  services = mapAttrs (service: attrs:
    attrs // { 
      portString = if attrs ? port
        then builtins.toString attrs.port
        else "";
      #TODO this might be able to directly grab the current hostname instead of having it passed in
      isEnabled = attrs.enable == true && attrs.host == hosts.${host};
    }
  ) servicesBase;

  portsUsed = concatMapAttrs (service: attrs: {
    ${attrs.portString} = "${service}";
  }) (filterAttrs (service: attrs: attrs ? port && attrs.host == hosts.${host}) services);
}

