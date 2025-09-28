{ config, pkgs, lib, catalog, ... }:

with lib;

let
	cfg = catalog.services.komga;

in {
	options.modules.komga = catalog.defaultOptions;

	config = mkIf cfg.enable {
		services.komga = {
			enable = true;
			settings.server.port = cfg.port;
			stateDir = "/data/media/.state/komga";
			group = "media";
  	};
	};
}