{ catalog, config, lib, ... }:

let
  cfg = catalog.services.navidrome;

in lib.mkIf cfg.isEnabled {
  users.users.navidrome = {
    uid = 2143;
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = cfg.port;
      MusicFolder = "/mnt/media/music";
      DataDir = "/state/navidrome/data";
      CacheDir = "/state/navidrome/cache";
      CoverJPGQuality = 100;
    };
    group = "media";
  };
}

