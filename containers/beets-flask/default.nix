{ catalog, config, inputs, lib, ... }:

let
  cfg = catalog.services.beets-flask;
  configDir = "/state/beets-flask";
  musicDir = "/mnt/media/music";
  uid = 3195;
  uidStr = toString uid;

in lib.mkIf cfg.isEnabled {
  users.users.beets-flask = {
    isSystemUser = true;
    uid = uid;
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

  systemd = {
    #TODO add below line back when discogs plugin issue fixed
    #\\cp -f ${inputs.self}/containers/beets-flask/requirements.txt ${configDir}/beets-flask/requirements.txt;
    services.podman-beets-flask.preStart = "
      \\cp -f ${inputs.self}/containers/beets-flask/beets-config.yaml ${configDir}/beets/config.yaml;
      \\cp -f ${inputs.self}/containers/beets-flask/beets-flask-config.yaml ${configDir}/beets-flask/config.yaml;
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
