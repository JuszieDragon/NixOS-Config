#This whole config stolen from here https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
{ config, lib, pkgs, ... }:

{
  users = {
    groups."file_share".gid = 2534;
    users."file_share" = {
      isSystemUser = true;
      group = "file_share";
      uid = 2534;
    };
  };
  
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "server min protocol" = "SMB3_00";
        };
        "files" = {
          "path" = "/mnt/files";
          "writable" = "yes";
          "browseable" = "yes";
          "force user" = "file_share";
          "force group" = "file_share";
          "create mask" = "0775";
          "directory mask" = "0775";
          validUsers = [ "justin" ];
        };
      };
    };

    avahi = {
      enable = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };  
}
