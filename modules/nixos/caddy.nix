{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.caddy;
  
  servicesValidForProxy = services: filterAttrs (n: v: v ? reverseProxy && v.reverseProxy != "none" && v.enable == true) services;

  #TODO figure out how to set propagation_timeout
  vHosts = builtins.listToAttrs (builtins.foldl' (acc: serviceName:
    let
      service = catalog.services.${serviceName} or catalog.containers.${serviceName};
      base = lib.removeAttrs service [ "hosts" ];
      isMultiHost = (builtins.length service.hosts) > 1;
      entriesForService = map (host:
        let
          url = 
            (if service ? subdomain 
              then "${service.subdomain}"
              else "${serviceName}") +
            (if isMultiHost
              then ".${host}"
              else "") +
            ".${catalog.domain}";
        in {
          name = url;
          value = if service.reverseProxy == "external" then {
            extraConfig = ''
              reverse_proxy ${catalog.hosts.${host}.ip}:${service.portString}
            '';
          } else {
            extraConfig = ''
              @internal { remote_ip 192.168.0.0/22 }
              handle @internal {
                reverse_proxy ${catalog.hosts.${host}.ip}:${service.portString} {
                  header_up Host {upstream_hostport}
                }
              }
              respond "Go away" 403
            '';
          };
        }
      ) service.hosts;
    in
      acc ++ entriesForService
  ) [] (builtins.attrNames (servicesValidForProxy (catalog.services // catalog.containers))));


in mkIf cfg.isEnabled {
  #networking.firewall.allowedTCPPorts = [ 80 443 ];

  age.secrets.caddy = {
    file = inputs.self + /secrets/caddy.age;
    owner = "caddy";
    group = "caddy";
  };

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-R1ZqQ8drcBQIH7cLq9kEvdg9Ze3bKkT8IAFavldVeC0=";
    };

    environmentFile = config.age.secrets.caddy.path;

    globalConfig = ''
      acme_dns porkbun {
        api_key {$API_KEY}
        api_secret_key {$API_SECRET_KEY} 
      }
    '';

      virtualHosts = vHosts;
  };
}

