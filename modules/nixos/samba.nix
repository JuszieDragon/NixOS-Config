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
          "reset on zero vc" = "yes";
        };
        "general" = {
          "path" = "/mnt/files";
          "writable" = "yes";
          "browseable" = "yes";
          "read only" = "no";
          "force user" = "file_share";
          "force group" = "file_share";
          "force create mode" = "0775";
          "force directory mode" = "0775";
        };
        "media" = {
          "path" = "/mnt/media";
          "writable" = "yes";
          "browseable" = "yes";
          "read only" = "no";
          "force user" = "justin";
          "force group" = "media";
          "force create mode" = "0775";
          "force directory mode" = "0775";
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

