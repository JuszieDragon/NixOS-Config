{ config, inputs, pkgs, lib, nixpkgs, catalog, ... }: 

with lib;

let
  cfg = catalog.services;

in {
  options.modules = {
    jellyfin = catalog.defaultOptions;
    sonarr = catalog.defaultOptions;
    radarr = catalog.defaultOptions;
    prowlarr = catalog.defaultOptions;
    transmission = catalog.defaultOptions;
  };

  config = {
    age.secrets.vpn.file = inputs.self + /secrets/vpn.age;

    services.deluge = {
      enable = true;
      web.enable = true;
    };

    nixarr = {
      enable = true;
      # These two values are also the default, but you can set them to whatever
      # else you want
      # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
      mediaDir = "/data/media";
      stateDir = "/data/media/.state/nixarr";

      vpn = {
        enable = false;
        # WARNING: This file must _not_ be in the config git directory
        # You can usually get this wireguard file from your VPN provider
        wgConf = config.age.secrets.vpn.path;
      };

      jellyfin = mkIf cfg.jellyfin.enable {
        enable = true;
      };

      prowlarr = mkIf cfg.prowlarr.enable {
        enable = true;
        vpn.enable = false;
        port = cfg.prowlarr.port;
      };

      radarr = mkIf cfg.radarr.enable {
        enable = true;
        port = cfg.radarr.port;
      };

      sonarr = mkIf cfg.sonarr.enable {
        enable = true;
      };
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
