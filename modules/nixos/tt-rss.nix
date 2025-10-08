{ config, pkgs, lib, catalog, ... }:

with lib;

let
	cfg = catalog.services.tt-rss;
	hostName = config.networking.hostName;
	domainName = "${cfg.subdomain or "tt-rss"}.${catalog.domain}";

in {
	options.modules.tt-rss = catalog.defaultOptions;

	config = mkIf (cfg.isEnabled hostName) {
		services.tt-rss = {
			enable = true;
			selfUrlPath = "https://${domainName}";
  	  virtualHost = null;
			themePackages = [ pkgs.tt-rss-theme-feedly ];
  	};

  	services.caddy.virtualHosts.${domainName}.extraConfig = ''
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
	};
}
