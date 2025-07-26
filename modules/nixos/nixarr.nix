{ config, pkgs, nixpkgs, ... }: {
  nixarr = {
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

    jellyfin = {
      enable = true;
      # These options set up a nginx HTTPS reverse proxy, so you can access
      # Jellyfin on your domain with HTTPS
      #expose.https = {
      #    enable = true;
      #    domainName = "your.domain.com";
      #    acmeMail = "your@email.com"; # Required for ACME-bot
      #};
    };

    transmission = {
      enable = true;
      #vpn.enable = true;
      #peerPort = 50000; # Set this to the port forwarded by your VPN
    };

    # It is possible for this module to run the *Arrs through a VPN, but it
    # is generally not recommended, as it can cause rate-limiting issues.
    #bazarr.enable = true;
    #lidarr.enable = true;
    prowlarr = { enable = true; };
    radarr.enable = true;
    #readarr.enable = true;
    sonarr.enable = true;
    #jellyseerr.enable = true;
  };

  services.caddy.virtualHosts."jellyfin.dragon.luxe".extraConfig = ''
    reverse_proxy 192.168.1.100:8096
  '';

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
