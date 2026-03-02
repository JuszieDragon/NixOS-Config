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

    last-defence-academy = {
      isNixos = true;
      ip = "192.168.1.5";
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

    centauri-carbon = {
      isNixos = false;
      ip = "192.168.2.102";
    };
  };

  hosts = mapAttrs (host: attrs:
    attrs // { hostName = host; }
  ) hostsBase;

  servicesBase = {
    jellyfin = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8096;
      reverseProxy = "external";
    };
    radarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 7878;
      reverseProxy = "internal";
    };
    sonarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8989;
      reverseProxy = "internal";
    };
    sonarr-anime = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8990;
      reverseProxy = "internal";
    };
    prowlarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 9696;
      reverseProxy = "internal";
    };
    qbittorrent = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8081;
      reverseProxy = "internal";
    };
    komga = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8082;
      reverseProxy = "internal";
    };
    yamtrack = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8084;
      reverseProxy = "internal";
    };
    yarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 7070;
      reverseProxy = "external";
    };
    scrutiny = {
      enable = true;
      hosts = [ "soul-matrix" "last-defence-academy" ];
      port = 8083;
      reverseProxy = "internal";
    };
    kaneo = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 5173;
      reverseProxy = "internal";
    };
    #TODO maybe setup dependent services under kaneo object for DRY
    kaneo-api = {
      enable = servicesBase.kaneo.enable;
      hosts = servicesBase.kaneo.hosts;
      port = 1337;
      reverseProxy = "internal";
    };
    kaneo-db = {
      enable = servicesBase.kaneo.enable;
      hosts = servicesBase.kaneo.hosts;
      port = 5432;
      reverseProxy = "none";
    };
    navidrome = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 4553;
      reverseProxy = "external";
    };
    beets-flask = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 5001;
      reverseProxy = "internal";
    };
    a2o4-server = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 9797;
      reverseProxy = "internal";
    };
    kavita = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 5000;
      reverseProxy = "internal";
    };

    openspeedtest = {
      enable = true;
      hosts = [ "soul-matrix" "night-city" "last-defence-academy" ];
      port = 3000;
      reverseProxy = "internal";
      subdomain = "speedtest";
    };
    romm = {
      enable = false;
      hosts = [ "night-city" ];
      port = 8282;
      reverseProxy = "internal";
    };
    caddy = {
      enable = true;
      hosts = [ "soul-matrix" ];
    };

    home-assistant = {
      enable = true;
      hosts = [ "home-assistant" ];
      port = 8123;
      reverseProxy = "internal";
    };

    revachol-syncthing = {
      enable = true;
      hosts = [ "revachol" ];
      port = 8384;
      reverseProxy = "internal";
      subdomain = "syncthing";
    };

    tracen-syncthing = {
      enable = true;
      hosts = [ "tracen" ];
      port = 8082;
      reverseProxy = "internal";
      subdomain = "syncthing";
    };

    cabin-syncthing = {
      enable = true;
      hosts = [ "cabin" ];
      port = 8384;
      reverseProxy = "internal";
      subdomain = "syncthing";
    };

    centauri-carbon-web-ui = {
      enable = true;
      hosts = [ "centauri-carbon" ];
      port = 80;
      reverseProxy = "internal";
      subdomain = "cc-web";
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
      isEnabled = attrs.enable == true && builtins.elem "${host}" attrs.hosts;
      host = hosts.${host};
    }
  ) servicesBase;

  portsUsed = concatMapAttrs (service: attrs: {
    ${attrs.portString} = "${service}";
  }) (filterAttrs (service: attrs: attrs ? port && builtins.elem "${host}" attrs.hosts) services);
}

