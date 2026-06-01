{ catalog, config, inputs, ... }:
let
 resticSrvCfg = catalog.services.restic-server;

in {
  age.secrets = {
    resticRepo = {
      file = inputs.self + /secrets/restic-repository-url.age;
      mode = "0400";
    };
    resticPwd = {
      file = inputs.self + /secrets/restic-server-password.age;
      mode = "0400";
    };
  };

  services.restic.backups = {
    soul-matrix = {
      initialize = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      paths = [
        "/state"
        "/mnt/files"
        "/mnt/media/doujinshi"
        "/mnt/media/gallery-dl"
        "/mnt/media/immich"
        "/mnt/media/fanfics"
        "/mnt/media/manga"
        "/mnt/media/music"
        "/mnt/media/torrents/doujinshi"
        "/mnt/media/torrents/torrent-files"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
        "--keep-yearly 1"
      ];
      passwordFile = config.age.secrets.resticPwd.path;
      repositoryFile = config.age.secrets.resticRepo.path;
    };
  };
}
