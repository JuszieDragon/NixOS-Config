{
  config,
  inputs,
  pkgs,
  ...
}: {
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
            "jellyfin.dragon.luxe".extraConfig = ''
                reverse_proxy 192.168.1.100:8096
            '';
            "radarr.dragon.luxe".extraConfig = ''
               reverse_proxy 192.168.1.100:7878
            '';
            "sonarr.dragon.luxe".extraConfig = ''
                reverse_proxy 192.168.1.100:8989
            '';
        };
    };
}
