{ config, pkgs, lib, ... }:

let
  hostName = "tt-rss.dragon.luxe";

in  {
  services.tt-rss = {
		enable = true;
		selfUrlPath = "https://${hostName}";
    virtualHost = null;
		themePackages = [ pkgs.tt-rss-theme-feedly ];
  };

  services.caddy.virtualHosts.${hostName}.extraConfig = ''
    root * ${config.services.tt-rss.root}/www

		php_fastcgi * unix/${config.services.phpfpm.pools.${config.services.tt-rss.pool}.socket} {
			capture_stderr
		}

		file_server {
			browse
		}
  '';

  # Workaround: Create PHP-FPM socket with Caddy user instead of non-existing nginx
	services.phpfpm.pools."${config.services.tt-rss.pool}".settings = {
		"listen.owner" = config.services.caddy.user;
		"listen.group" = config.services.caddy.group;
	};
}
