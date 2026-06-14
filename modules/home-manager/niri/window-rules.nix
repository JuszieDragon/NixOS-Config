_: {
  /*
  Kogan: DP-1
  Philips: DP-2
  Viewsonic: DP-3
  LG C4: HDMI-A-1
  */

  programs.niri.settings = {
    window-rules = [
      {
        matches = [
          { app-id = "steam"; }
          { app-id = "feishin"; }
        ];
        open-on-output = "DP-2";
        open-maximized = true;
      }
      {
        matches = [ { app-id = "vesktop"; } ];
        open-on-output = "DP-3";
        open-maximized = true;
      }
      {
        matches = [
          { app-id = "gamescope"; }
          { app-id = "steam_app_.+"; }
        ];
        open-on-output = "DP-1";
        open-fullscreen = true;
      }
      {
        matches = [
          {
            #title = "NIKKE";
            app-id = "steam_proton";
          }
        ];
        open-on-workspace = "Nikke";
        open-fullscreen = true;
      }
      {
        # Make steam notification toast appear in the bottom right
        #TODO fix match
        matches = [
          {
            app-id = "steam";
            title = "^notificationtoasts_\d+_desktop$";
          }
        ];
        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "bottom-right";
        };
        open-focused = false;
        open-floating = true;
      }
    ];
    workspaces = {
      "Nikke" = {
        open-on-output = "DP-1";
      };
    };
  };
}
