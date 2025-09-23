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

  fileSystems."/mnt/qBittorrent" = {
    device = "//192.168.1.1/Files/qBittorrent";
    fsType = "cifs";
    options = sharedOptions ++ [
      #TODO hardcode this uid in qbittorrent.nix or maybe in nixarr overlay for globals file
      # https://github.com/rasmus-kirk/nixarr/blob/main/util/globals/default.nix
      "uid=987"
      #"uid=${toString users.users.qbittorrent.uid}"
      "gid=${toString config.util-nixarr.globals.gids.media}"
    ];
  };

  fileSystems."/mnt/Roms" = {
    device = "//192.168.1.1/Files/RomM";
    fsType = "cifs";
    options = sharedOptions;
  };

  fileSystems."/mnt/NAS/Plex" = {
    device = "//192.168.1.1/Plex";
    fsType = "cifs";
    options = sharedOptions;
  };
}