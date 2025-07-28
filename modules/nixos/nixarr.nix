{ config, pkgs, lib, nixpkgs, catalog, ... }: 

with lib;

let
  cfg = config.modules;

in {
  options.modules = {
    jellyfin = catalog.defaultOptions;
    sonarr = catalog.defaultOptions;
    radarr = catalog.defaultOptions;
    prowlarr = catalog.defaultOptions;
    transmission = catalog.defaultOptions;
  };

  config.nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/data/media";
    stateDir = "/data/media/.state/nixarr";

    vpn = {
      #enable = true;
      # WARNING: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      #wgConf = "./france_switzerland_1.conf";
    };

    jellyfin = mkIf cfg.jellyfin.enable {
      enable = true;
    };

    transmission = mkIf cfg.transmission.enable {
      enable = true;
      uiPort = strings.toInt cfg.transmission.port;
      #vpn.enable = true;
      #peerPort = 50000; # Set this to the port forwarded by your VPN
    };

    prowlarr = mkIf cfg.prowlarr.enable {
      enable = true;
      port = strings.toInt cfg.prowlarr.port;
    };

    radarr = mkIf cfg.radarr.enable {
      enable = true;
      port = strings.toInt cfg.radarr.port;
    };

    sonarr = mkIf cfg.sonarr.enable {
      enable = true;
    };
  };

  #nixpkgs.overlays = with pkgs; [
  #(
  #  final: prev:
  #    {
  #      jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
  #        installPhase = ''
  #          runHook preInstall

  # this is the important line
  #          sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

  #          mkdir -p $out/share
  #          cp -a dist $out/share/jellyfin-web

  #          runHook postInstall
  #        '';
  #      });
  #    }
  #)
  #];
}
