{ config, inputs, pkgs, my-pkgs, lib, catalog, ... }: 

with lib;

let
  cfg = catalog.services.qbittorrent;

  dataDir = "/mnt/media/torrents";
  stateDir = "/state";

in rec {
  users.users.qbittorrent = mkIf (services.qbittorrent.enable) {
    isSystemUser = true;
    group = "media";
    uid = 987;
  };

  services.qbittorrent = {
    enable = cfg.isEnabled;
    user = "qbittorrent";
    group = "media";
    profileDir = stateDir;
    webuiPort = cfg.port;
    extraArgs = [
      "--confirm-legal-notice"
    ];
    serverConfig = {
      AutoRun = {
        enabled = true;
        #TODO figure out how to stop escaped double quotes from being removed from the generated config file so I can use the below solution
        #https://github.com/qbittorrent/qBittorrent/issues/8016
        #This chmods the whole catagory folder, not great but it works
        program = "chmod -R 775 %D";
      };
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
          TempPath = "${dataDir}/downloading";
          TempPathEnabled = true;
          TorrentExportDirectory = "${dataDir}/torrent-files/";
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
      "Anime".save_path = "${dataDir}/sonarr-anime";
      "Doujinshi".save_path = "${dataDir}/doujinshi";
      "Games".save_path = "${dataDir}/games";
      "Manga".save_path = "${dataDir}/manga";
      "Misc".save_path = "${dataDir}/misc";
      "Movies".save_path = "${dataDir}/radarr";
      "Seeding".save_path = "${dataDir}/seeding";
      "TV Shows".save_path = "${dataDir}/sonarr";
    };
  };
}

