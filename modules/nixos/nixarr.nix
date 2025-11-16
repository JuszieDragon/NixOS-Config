{ config, inputs, pkgs, lib, nixpkgs, catalog, ... }: 

with lib;

let
  cfg = catalog.services;
  hostName = config.networking.hostName;

in {
  age.secrets.vpn.file = inputs.self + /secrets/vpn.age;

  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/mnt/media";
    stateDir = "/state/nixarr";

    vpn = {
      enable = false;
      # WARNING: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      wgConf = config.age.secrets.vpn.path;
    };

    jellyfin = {
      enable = cfg.jellyfin.isEnabled hostName;
    };

    prowlarr = {
      enable = cfg.prowlarr.isEnabled hostName;
      vpn.enable = false;
      port = cfg.prowlarr.port;
    };

    radarr = {
      enable = cfg.radarr.isEnabled hostName;
      port = cfg.radarr.port;
    };

    sonarr = {
      enable = cfg.sonarr.isEnabled hostName;
    };
  };
}

