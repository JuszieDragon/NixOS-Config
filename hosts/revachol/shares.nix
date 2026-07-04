
{ catalog, config, inputs, lib, pkgs, ... }:
let
  sharedOptions = {
    fsType = "cifs";
    options = [
      "credentials=${config.age.secrets.share.path}"
      "uid=1000"
      "gid=100"
      "auto"
      "nofail"
      "user"
      "_netdev"
      "vers=3.0"
    ];
  };

  nasIp = builtins.toString catalog.hosts.soul-matrix.ip;

in {
  environment.systemPackages = with pkgs; [ cifs-utils samba ];

  # Allow users to mount cifs shares
  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  age.secrets.share.file = inputs.self + /secrets/share.age;

  fileSystems = {
    "/mnt/nas/general" = sharedOptions // {
      device = "//${nasIp}/general";
    };
    "/mnt/nas/media" = sharedOptions // {
      device = "//${nasIp}/media";
    };
  };
}

