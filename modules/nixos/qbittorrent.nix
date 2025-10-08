{ config, inputs, pkgs, my-pkgs, lib, catalog, ... }: 

with lib;

let
  cfg = catalog.services.qbittorrent;
  hostName = config.networking.hostName;

  mediaDir = "/data/media/torrents";
  nasDir = "/mnt/qBittorrent";

in {
  options.modules.qbittorrent = catalog.defaultOptions;

  config = mkIf (cfg.isEnabled hostName) {
    users.users.qbittorrent = {
      isSystemUser = true;
      group = "media";
      uid = 987;
    };

    services.qbittorrent = {
      enable = true;
      group = "media";
      profileDir = "/data/media/.state";
      webuiPort = cfg.port;
      extraArgs = [
        "--confirm-legal-notice"
      ];
      serverConfig = {
        BitTorrent = {
          Session = {
            DisableAutoTMMByDefault = false;
            DisableAutoTMMTriggers = {
              CategorySavePathChanged = false;
              DefaultSavePathChanged = false;
            };
            MaxActiveDownloads = "10";
            MaxActiveTorrents = "50";
            MaxActiveUploads = "20";
            MaxConnections = "-1";
            MaxConnectionsPerTorrent = "-1";
            MaxUploads = "-1";
            MaxUploadsPerTorrent = "-1";
            TempPath = "${mediaDir}/downloading";
            TempPathEnabled = true;
            TorrentExportDirectory = "${nasDir}/torrent-files/";
          };
        };
        LegalNotice = {
          Accepted = true;
        };
        Preferences = {
          WebUI = {
            AuthSubnetWhitelist = "192.168.0.0/22";
            AuthSubnetWhitelistEnabled = true;
            Password_PBKDF2 = "@ByteArray(6V/U+piHm3jT+v6nvtJu7Q==:p7x9j9tM37ZqK5ytCLi+GbbxgBeLl1BtE09FPegVn24W+SF8Nd/VKzSrNEtZCDno5x9v36xmQViY/FtXIhE3CA==)";
            Username = "justinj0";
          };
          BitTorrent = {
            MaxUploads = "-1";
            MaxUploadsPerTorrent = "-1";
          };
          Queueing = {
            MaxActiveDownloads = "-1";
            MaxActiveTorrents = "-1";
            MaxActiveUploads = "-1";
            QueueingEnabled = true;
          };
        };
      };
      categories = {
        "Anime".save_path = "${mediaDir}/sonarr-anime";
        "Doujinshi".save_path = "${mediaDir}/doujinshi";
        "Manga".save_path = "${mediaDir}/manga";
        "Misc".save_path = "${nasDir}/Misc";
        "Movies".save_path = "${mediaDir}/radarr";
        "Seeding".save_path = "${nasDir}/Seeding";
        "TV Shows".save_path = "${mediaDir}/sonarr";
      };
    };
  };
}