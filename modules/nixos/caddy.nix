{
  config,
  pkgs,
  ...
}: {
    services.caddy = {
        enable = false;
        package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/duckdns@v0.4.0" ];
            hash = "sha256-0WGKeJhFPUp7ajwhEci5MyyFc5zyvXdBNQAjsAl88sM=";
        };
    };
}
