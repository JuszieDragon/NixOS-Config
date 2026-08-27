{ lib, host, ... }:

with lib;

rec {
  domain = "dragon.luxe";

  /*
    options:
      host:
        isNixos: is the host nixos or not? not used atm
        ip: IP address to the host
        syncthingId: syncthing identifier
      services:
        enable: if the service is enabled or not
        host: Which host to run the service on
        port: Which port to bind the service to
        reverseProxy: What type of reverse proxy to use, options are: internal, external, TODO add local DNS server to handle internal instead of caddy
        subdomain: Override the name used by the reverse proxy
        module: Override the module filename if it doesn't match service name
        noModule: Don't add service to module import list
  */

  hostsBase = {
    night-city = {
      isNixos = true;
      ip = "192.168.1.100";
    };

    soul-matrix = {
      isNixos = true;
      ip = "192.168.1.1";
      syncthingId = "7WFVTVY-RL74QRT-34DFXU7-G25ZSNU-2GSP3OM-E3UCZ6I-JQC7KM3-OHNNWAB";
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
      syncthingId = "6XH43I5-OWVOWSB-7K3YP5H-5KRNBZA-QRFBT5E-6AU5FI7-R5FKVVZ-24DAKAX";
    };

    eden = {
      isNixos = true;
      ip = "192.168.2.8";
      syncthingId = "OGL6S3Y-MVSWBMH-RNGQJ5J-RQ3GY3F-MHYDESZ-CHOHYZO-V65CJKZ-RAQCEAJ";
    };

    mementos = {
      isNixos = true;
      ip = "192.168.0.3";
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
      module = "nixarr";
    };
    radarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 7878;
      reverseProxy = "internal";
      module = "nixarr";
    };
    sonarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8989;
      reverseProxy = "internal";
      module = "nixarr";
    };
    prowlarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 9696;
      reverseProxy = "internal";
      module = "nixarr";
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
    yarr = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 7070;
      reverseProxy = "external";
    };
    scrutiny = {
      enable = true;
      hosts = [ "soul-matrix" "last-defence-academy" "mementos" ];
      port = 8083;
      reverseProxy = "internal";
    };
    navidrome = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 4553;
      reverseProxy = "external";
    };
    a2o4-server = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 9797;
      reverseProxy = "internal";
      noModule = true;
    };
    kavita = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 5000;
      reverseProxy = "internal";
    };
    forgejo = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 3001;
      reverseProxy = "internal";
    };
    caddy = {
      enable = true;
      hosts = [ "mementos" ];
    };
    immich = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 2283;
      reverseProxy = "external";
    };
    kosync = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 7200;
      reverseProxy = "external";
    };
    grafana = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8010;
      reverseProxy = "internal";
    };
    prometheus = {
      enable = true;
      hosts = [ "soul-matrix" "night-city" "last-defence-academy" ];
      port = 3020;
    };
    loki = {
      enable = true;
      hosts = [ "soul-matrix" "night-city" "last-defence-academy" ];
      port = 3100;
    };
    vector = {
      enable = true;
      hosts = [ "soul-matrix" "night-city" "last-defence-academy" ];
      port = 9598;
    };
    librespeed = {
      enable = true;
      hosts = [ "soul-matrix" "night-city" "last-defence-academy" "mementos" ];
      frontendHost = "soul-matrix";
      port = 3002;
    };
    sws = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8085;
    };
    gotify = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8072;
      reverseProxy = "external";
    };
    syncthing = {
      enable = true;
      hosts = [ "soul-matrix" "revachol" "eden" ];
      port = 8384;
      reverseProxy = "internal";
    };

    restic-server = {
      enable = true;
      hosts = [ "last-defence-academy" ];
      port = 8000;
    };
  };

  containersBase = {
    sonarr-anime = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8990;
      reverseProxy = "internal";
    };
    yamtrack = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 8084;
      reverseProxy = "internal";
    };
   # kaneo = {
   #   enable = true;
   #   hosts = [ "soul-matrix" ];
   #   port = 5173;
   #   reverseProxy = "internal";
   # };
   # #TODO maybe setup dependent services under kaneo object for DRY
   # kaneo-api = {
   #   enable = servicesBase.kaneo.enable;
   #   hosts = servicesBase.kaneo.hosts;
   #   port = 1337;
   #   reverseProxy = "internal";
   #   noModule = true;
   # };
   # kaneo-db = {
   #   enable = servicesBase.kaneo.enable;
   #   hosts = servicesBase.kaneo.hosts;
   #   port = 5432;
   #   noModule = true;
   # };
    beets-flask = {
      enable = true;
      hosts = [ "soul-matrix" ];
      port = 5001;
      reverseProxy = "internal";
      module = "beets-flask/default";
    };
    romm = {
      enable = false;
      hosts = [ "night-city" ];
      port = 8282;
      reverseProxy = "internal";
    };
  };

  populate = servicesToPop: mapAttrs (_service: attrs:
    attrs // { 
      portString = if attrs ? port
        then builtins.toString attrs.port
        else "";
      #TODO this might be able to directly grab the current hostname instead of having it passed in
      isEnabled = attrs.enable && builtins.elem "${host}" attrs.hosts;
      host = hosts.${host};
    }
  ) servicesToPop;

  services = populate servicesBase;
  containers = populate containersBase;

  portsUsed = concatMapAttrs (service: attrs: {
    ${attrs.portString} = "${service}";
  }) (
      filterAttrs (_service: attrs: attrs ? port && builtins.elem "${host}" attrs.hosts) services //
      filterAttrs (_service: attrs: attrs ? port && builtins.elem "${host}" attrs.hosts) containers
    );

  getModuleName = module: attrs: 
    if attrs ? module
      then "${attrs.module}"
      else "${module}";

  modulePathsForHost = servicesToMap: path: lists.unique (
    lib.attrsets.mapAttrsToList (module: attrs:
      path + (/. + (getModuleName module attrs)) + ".nix"
    ) (filterAttrs (_n: v: v.isEnabled && !(v ? noModule)) servicesToMap)
  );

  servicePathsForHost = modulePathsForHost services ./modules/nixos;
  containerPathsForHost = modulePathsForHost containers ./containers;
}

