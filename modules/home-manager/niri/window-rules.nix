{ config, lib, pkgs, ... }: {
  /*
  Kogan: DP-1
  Philips: DP-2
  Viewsonic: DP-3
  LG C4: HDMI-A-1
  */

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "steam"; } ];
      open-maximized = true;
      open-on-output = "DP-3";
    }
    {
      matches = [ { app-id = "vesktop"; } ];
      open-maximized = true;
      open-on-output = "DP-2";
    }
  ];
}
