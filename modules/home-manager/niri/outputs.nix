{ lib, pkgs, ... }: {
  programs.niri.settings.outputs = {
    #Kogan
    DP-1 = {
      position = { x = 0; y = 1080; };
    };
    #Philips
    DP-2 = {
      position = { x = 3440; y = 600; };
      transform.rotation = 270;
    };
    #Viewsonic
    DP-3 = {
      position = { x = 800; y = 0; };
    };
    #LG C4
    HDMI-A-1.enable = false;
  };
}
