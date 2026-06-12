{ config, ... }: {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    "Mod+T" = {
      hotkey-overlay.title = "Alacritty";
      action.spawn = "alacritty";
    };
    "Mod+Shift+Space" = {
      hotkey-overlay.title = "Fuzzel";
      action.spawn = "fuzzel";
    };

    "Mod+Space" = { action.spawn = [ "noctalia" "msg" "panel-toggle" "launcher" ]; };
    "Mod+S" = { action.spawn = [ "noctalia" "msg" "panel-toggle" "control-center" ]; };
    "Mod+Comma" = { action.spawn = [ "noctalia" "msg" "settings-toggle" ]; };

    "XF86AudioPlay" = {
      action.spawn = ["playerctl" "play-pause"];
      allow-when-locked = true;
    };
    "XF86AudioNext" = {
      action.spawn = ["playerctl" "next"];
      allow-when-locked = true;
    };
    "XF86AudioPrev" = {
      action.spawn = ["playerctl" "previous"];
      allow-when-locked = true;
    };
    XF86AudioRaiseVolume = {
      action.spawn = [ "noctalia" "msg" "volume-up"];
      allow-when-locked = true;
    };
    XF86AudioLowerVolume = {
      action.spawn = [ "noctalia" "msg" "volume-down" ];
      allow-when-locked = true;
    };
    XF86AudioMute = {
      action.spawn = [ "noctalia" "msg" "volume-mute" ];
      allow-when-locked = true;
    };
    XF86MonBrightnessUp = {
      action.spawn = [ "noctalia" "msg" "brightness-up" ];
      allow-when-locked = true;
    };
    XF86MonBrightnessDown = {
      action.spawn = [ "noctalia" "msg" "brightness-down" ];
      allow-when-locked = true;
    };
    # "XF86AudioRaiseVolume" = {
    #   action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
    #   allow-when-locked = true;
    # };
    # "XF86AudioLowerVolume" = {
    #   action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
    #   allow-when-locked = true;
    # };
    # "XF86AudioMute" = {
    #   action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "toggle"];
    #   allow-when-locked = true;
    # };

    "Mod+O" = {
      action = toggle-overview;
      repeat = false;
    };
    "Mod+Q" = {
      action = close-window;
      repeat = false;
    };

    "Mod+Left" = { action = focus-column-left; };
    "Mod+Down" = { action = focus-window-down; };
    "Mod+Up" = { action = focus-window-up; };
    "Mod+Right" = { action = focus-column-right; };
    #"Mod+H" = { action = focus-column-left; };
    #"Mod+J" = { action = focus-window-down; };
    #"Mod+K" = { action = focus-window-up; };
    #"Mod+L" = { action = focus-column-right; };

    "Mod+Ctrl+Left" = { action = move-column-left; };
    "Mod+Ctrl+Down" = { action = move-window-down; };
    "Mod+Ctrl+Up" = { action = move-window-up; };
    "Mod+Ctrl+Right" = { action = move-column-right; };
    #"Mod+Ctrl+H" = { action = move-column-left; };
    #"Mod+Ctrl+J" = { action = move-window-down; };
    #"Mod+Ctrl+K" = { action = move-window-up; };
    #"Mod+Ctrl+L" = { action = move-column-right; };

    "Mod+F" = { action = maximize-column; };
    "Mod+Ctrl+F" = { action = fullscreen-window; };
    "Mod+Page_Up" = { action = focus-workspace-up; };
    "Mod+Page_Down" = { action = focus-workspace-down; };
  };
}
