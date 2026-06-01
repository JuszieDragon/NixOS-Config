{ config, inputs, pkgs, lib, catalog, ... }:

with lib;

let
  cfg = catalog.services.caddy;

  propagation_timeout = /*caddy*/''
    tls {
      issuer acme {
        propagation_timeout 5m
        propagation_delay 30s
      }
    }
  '';

  servicesValidForProxy = services: filterAttrs (_n: v: v ? reverseProxy && v.enable) services;

  vHosts = builtins.listToAttrs (builtins.foldl' (acc: serviceName:
    let
      service = catalog.services.${serviceName} or catalog.containers.${serviceName};
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
          value = (if service.reverseProxy == "external" then {
            extraConfig = /*caddy*/''
              ${propagation_timeout}
              reverse_proxy ${catalog.hosts.${host}.ip}:${service.portString}
            '';
          } else {
            extraConfig = /*caddy*/''
              ${propagation_timeout}
              @internal { remote_ip 192.168.0.0/22 }
              handle @internal {
                reverse_proxy ${catalog.hosts.${host}.ip}:${service.portString} {
                  header_up Host {upstream_hostport}
                }
              }
              abort
            '';
          }) // {
            logFormat = /*caddy*/''
              output file /var/log/caddy/${url}.log {
                roll_size 100MiB
                roll_keep 5
                roll_keep_for 100d
                mode 0640
              }
              format json
              level INFO
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
      hash = "sha256-pt4jyNcfacZKxzRH7zW7l2/+YfmVKWxGD4JTyWpvD1E=";
    };

    environmentFile = config.age.secrets.caddy.path;

    logFormat = /*caddy*/''
      output file /var/log/caddy/caddy_main.log {
        roll_size 100MiB
        roll_keep 5
        roll_keep_for 100d
        mode 0640
      }
      format json
      level INFO
    '';

    globalConfig = /*caddy*/''
        acme_dns porkbun {
          api_key {$API_KEY}
          api_secret_key {$API_SECRET_KEY}
        }

        metrics
    '';

    virtualHosts = vHosts;
  };
}

