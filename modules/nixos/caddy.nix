{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = config.modules.caddy;
  
  servicesToProxyConf = filterAttrs (n: v: v ? reverseProxy && v.reverseProxy != "none" && v ? port && v.enable == true) config.modules;
  #servicesToProxyConfTrace = mapAttrs' (n: v: nameValuePair (traceVal n) (traceVal v)) servicesToProxyConf;

  vHosts = mapAttrs' (service: sconf:
    nameValuePair 
    (
      if sconf ? subdomain then
        "${sconf.subdomain}.${catalog.domain}"
      else
        "${service}.${catalog.domain}"
    )
    (
      #TODO really need to figure out how to setup propagation_timeout with this setup
      if sconf.reverseProxy == "external" then {
        extraConfig = ''
          reverse_proxy localhost:${sconf.port}
        '';
      } else {
        extraConfig = ''
          @internal { remote_ip 192.168.0.0/22 }
          handle @internal {
            reverse_proxy localhost:${sconf.port}
          }
          respond "Go away" 403
        '';
      }
    )
  #) servicesToProxyConfTrace;
  ) servicesToProxyConf;

  #vHostsTrace = mapAttrs' (n: v: nameValuePair (traceVal n) (traceVal v)) vHosts;

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
        hash = "sha256-sa+L2YoTM1ZfhfowoCZwmggrUsqw0NmGWRK45TevxFo=";
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
    };
  };
}
