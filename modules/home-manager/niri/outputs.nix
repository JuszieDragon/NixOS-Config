_: {
  programs.niri.settings.outputs = {
    #Kogan
    DP-1 = {
      position = { x = 0; y = 1440; };
    };
    #Vertical MSI
    DP-2 = {
      position = { x = 3440; y = 550; };
      transform.rotation = 270;
    };
    #MSI
    DP-3 = {
      position = { x = 480; y = 0; };
    };
    #LG C4
    HDMI-A-1.enable = false;
  };
}
