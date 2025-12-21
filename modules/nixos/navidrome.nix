{ catalog, config, lib, ... }:

let
  cfg = catalog.services.navidrome;
  configDir = "/state/navidrome";

in lib.mkIf cfg.isEnabled {
  users.users.navidrome = {
    uid = 2143;
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = cfg.port;
      MusicFolder = "/mnt/media/music/imported";
      DataFolder = "${configDir}/data";
      CacheFolder = "${configDir}/cache";
      CoverJpegQuality = 100;
    };
    group = "media";
  };
}

