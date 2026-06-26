{ catalog, config, inputs, lib, pkgs, ... }:

let
  cfg = catalog.containers.beets-flask;
  configDir = "/state/beets-flask";
  musicDir = "/mnt/media/music";
  uid = 3195;
  uidStr = toString uid;

in lib.mkIf cfg.isEnabled {
  users.users.beets-flask = {
    isSystemUser = true;
    inherit uid;
    group = "media";
  };

  virtualisation.oci-containers.containers = {
    beets-flask = {
      image = "pspitzner/beets-flask:v1.2.1";
      ports = [ "${cfg.portString}:5001" ];
      environment = {
        TZ = "Australia/Hobart";
        USER_ID = uidStr;
        GROUP_ID = toString config.users.groups.media.gid;
      };
      volumes = [
        (configDir + ":/config")
        "${musicDir}/inbox/:/music/inbox"
        "${musicDir}/imported/:/music/imported"
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "music-download" ''
      if [[ "$EUID" -ne 0 ]]; then
        echo "Please run this script with sudo or as root"
        exit 1
      fi
      if [[ -z "$1" ]]; then
        echo "Need to pass dir name";
        exit 1;
      fi
      if [[ -z "$2" ]]; then
        echo "Need to pass file type";
        exit 1;
      fi
      if [[ "$2" != "zip" && "$2" != "file" ]]; then
        echo "Filetype must be \"zip\" or \"file\"";
        exit 1;
      fi
      if [[ -z "$3" ]]; then
        echo "Need to pass a url to download";
        exit 1;
      fi
      DIR=${musicDir}/inbox/$1;
      mkdir "$DIR";
      if [[ "$2" == "zip" ]]; then
        ${pkgs.curl}/bin/curl -sSL $3 | ${pkgs.libarchive}/bin/bsdtar -xvf- -C "$DIR";
      else
        ${pkgs.curl}/bin/curl --output-dir "$DIR" -sSLOJ $3;
      fi
      sudo chown -R beets-flask:media "$DIR";
    '')
  ];

  systemd = {
    services.podman-beets-flask.preStart = "
      \\cp -f ${inputs.self}/containers/beets-flask/beets-config.yaml ${configDir}/beets/config.yaml;
      \\cp -f ${inputs.self}/containers/beets-flask/beets-flask-config.yaml ${configDir}/beets-flask/config.yaml;
      \\cp -f ${inputs.self}/containers/beets-flask/requirements.txt ${configDir}/beets-flask/requirements.txt;
    ";
    #TODO keep an eye on this issue to copy file and set permissions in dir not owned by root
    #https://github.com/systemd/systemd/issues/31030
    tmpfiles.rules = [
      "d ${configDir} 0755 beets-flask media -"
      "d ${configDir}/beets 0755 beets-flask media -"
      "d ${configDir}/beets-flask 0755 beets-flask media -"
      "d ${musicDir}/inbox 0755 beets-flask media -"
      "d ${musicDir}/imported 0755 beets-flask media -"
    ];
  };
}
