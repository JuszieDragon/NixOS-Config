{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: 

with lib;

let cfg = config.modules.caddy;

in {
    options.modules.caddy.enable = mkEnableOption "Setup Caddy reverse proxy";

    config = mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = [ 80 443 ];

        #TODO pass the secret root path in so it's only defined once
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
                    api_key {env.api_key}
                    api_secret_key {env.api_secret_key} 
                }
            '';

            virtualHosts = {
                "dragon.luxe".extraConfig = ''
                    respond "There is nothing here."
                '';
            };
        };
    };
}
