#This whole config stolen from here https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
{ config, lib, pkgs, ... }:

{
  services = {
    samba = {
      enable = true;
      #package = pkgs.samba4Full;
      openFirewall = true;
      settings = {
      	global = {
	  "server min protocol" = "SMB3_00";
	};
	"files" = {
          path = "/mnt/files";
          writable = "yes";
	  browseable = "yes";
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
