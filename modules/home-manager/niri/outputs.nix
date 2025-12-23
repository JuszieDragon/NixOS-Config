{ lib, pkgs, ... }: {
  programs.niri.settings.outputs = {
    #Kogan
    DP-1 = {
      position = { x = 200; y = 1080; };
    };
    #Philips
    DP-2 = {
      position = { x = 0; y = 0; };
    };
    #Viewsonic
    DP-3 = {
      position = { x = 1920; y = 0; };
    };
    #LG C4
    HDMI-A-1.enable = false;
  };
}
