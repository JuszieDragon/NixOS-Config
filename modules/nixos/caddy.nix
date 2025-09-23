{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.caddy;
  
  servicesValidForProxy = services: filterAttrs (n: v: v ? reverseProxy && v.reverseProxy != "none" && v.enable == true) services;

  vHosts = mapAttrs' (serviceName: service:
    nameValuePair
    (
      if service ? subdomain 
        then "${service.subdomain}.${catalog.domain}"
        else "${serviceName}.${catalog.domain}"
    )
    (
      #TODO really need to figure out how to setup propagation_timeout with this setup
      if service.reverseProxy == "external" then {
        extraConfig = ''
          reverse_proxy ${service.host.ip}:${service.portString}
        '';
      } else {
        extraConfig = ''
          @internal { remote_ip 192.168.0.0/22 }
          handle @internal {
            reverse_proxy ${service.host.ip}:${service.portString} {
              header_up Host {upstream_hostport}
            }
          }
          respond "Go away" 403
        '';
      }
    )
  ) (servicesValidForProxy catalog.services);

in {
  options.modules.caddy.enable = mkEnableOption "Setup Caddy reverse proxy";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    age.secrets.caddy = {
      file = inputs.self + /secrets/caddy.age;
      owner = "caddy";
      group = "caddy";
    };

    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
        hash = "sha256-g/Nmi4X/qlqqjY/zoG90iyP5Y5fse6Akr8exG5Spf08=";
      };

      environmentFile = config.age.secrets.caddy.path;

      globalConfig = ''
        acme_dns porkbun {
          api_key {$API_KEY}
          api_secret_key {$API_SECRET_KEY} 
        }
      '';

      # virtualHosts = {
      #     "dragon.luxe".extraConfig = ''
      #         respond "There is nothing here."
      #     '';
      # };

      #virtualHosts = vHostsTrace;
      virtualHosts = vHosts;
      #virtualHosts = test;
    };
  };
}
