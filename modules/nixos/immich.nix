{ catalog, lib, ... }: 

let
  cfg = catalog.services.immich;
  mediaLocation = "/mnt/media/immich";
  id = 4286;

in {
  users = lib.mkIf cfg.isEnabled {
    users.immich = {
      uid = id;
      extraGroups = [ "video" "render" ];
    };
    groups.immich.gid = id;
  };

  systemd.tmpfiles.settings.immich."${mediaLocation}".d = {
    user = "immich";
    group = "immich";
    mode = "0775";
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = cfg.port;
    inherit mediaLocation;
    #settings.server.externalDomain = "https://immich.${catalog.domain}";
  };
}
