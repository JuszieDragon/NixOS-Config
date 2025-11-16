{ config, inputs, lib, pkgs, ... }: 
let 
  inherit (builtins) toString;
  sharedOptions = [
    "credentials=${config.age.secrets.share.path}" 
    "rw"
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
    "vers=3.0"
  ];

in {
  environment.systemPackages = with pkgs; [ cifs-utils samba ];

  age.secrets.share.file = inputs.self + /secrets/share.age; 

  fileSystems = {
    "/mnt/Roms" = {
      device = "//192.168.1.1/general/RomM";
      fsType = "cifs";
      options = sharedOptions;
    };

    "/mnt/backups" = {
      device = "//192.168.1.1/general/Backups";
      fsType = "cifs";
      options = sharedOptions;
    };
  };
}

