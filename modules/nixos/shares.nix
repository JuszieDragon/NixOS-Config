{ config, lib, pkgs, ... }: {
  fileSystems."/mnt/NAS/Files" = {
    device = "//192.168.1.1/Files";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},username=justinj0,password=Qywter101" ];
  };

  fileSystems."/mnt/NAS/Plex" = {
    device = "//192.168.1.1/Plex";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},username=justinj0,password=Qywter101" ];
  };
}
