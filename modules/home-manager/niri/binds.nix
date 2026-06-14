{ config, ... }: {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    "Mod+T" = {
      hotkey-overlay.title = "Alacritty";
      action.spawn = "alacritty";
    };

    "Mod+Space" = {
      hotkey-overlay.title = "Noctalia launcher";
      action.spawn = [ "noctalia" "msg" "panel-toggle" "launcher" ]; };
    "Mod+S" = {
      hotkey-overlay.title = "Noctalia control center";
      action.spawn = [ "noctalia" "msg" "panel-toggle" "control-center" ];
    };
    "Mod+Comma" = {
      hotkey-overlay.title = "Noctalia settings";
      action.spawn = [ "noctalia" "msg" "settings-toggle" ];
    };

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
    "XF86AudioRaiseVolume" = {
      action.spawn = [ "noctalia" "msg" "volume-up"];
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action.spawn = [ "noctalia" "msg" "volume-down" ];
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action.spawn = [ "noctalia" "msg" "volume-mute" ];
      allow-when-locked = true;
    };
    "XF86MonBrightnessUp" = {
      action.spawn = [ "noctalia" "msg" "brightness-up" ];
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action.spawn = [ "noctalia" "msg" "brightness-down" ];
      allow-when-locked = true;
    };

    "Mod+O" = {
      action = toggle-overview;
      repeat = false;
    };

    "Mod+Left".action.focus-column-left = [ ];
    "Mod+H".action.focus-column-left = [ ];
    "Mod+Right".action.focus-column-right = [ ];
    "Mod+L".action.focus-column-right = [ ];
    "Mod+Up".action.focus-window-or-workspace-up = [ ];
    "Mod+K".action.focus-window-or-workspace-up = [ ];
    "Mod+Down".action.focus-window-or-workspace-down = [ ];
    "Mod+J".action.focus-window-or-workspace-down = [ ];

    "Mod+Ctrl+Left".action.move-column-left = [ ];
    "Mod+Ctrl+H".action.move-column-left = [ ];
    "Mod+Ctrl+Right".action.move-column-right = [ ];
    "Mod+Ctrl+L".action.move-column-right = [ ];
    "Mod+Ctrl+Up".action.move-window-up-or-to-workspace-up = [ ];
    "Mod+Ctrl+K".action.move-window-up-or-to-workspace-up = [ ];
    "Mod+Ctrl+Down".action.move-window-down-or-to-workspace-down = [ ];
    "Mod+Ctrl+J".action.move-window-down-or-to-workspace-down = [ ];

    "Mod+Shift+Left".action.focus-monitor-left = [ ];
    "Mod+Shift+H".action.focus-monitor-left = [ ];
    "Mod+Shift+Right".action.focus-monitor-right = [ ];
    "Mod+Shift+L".action.focus-monitor-right = [ ];
    "Mod+Shift+Up".action.focus-monitor-up = [ ];
    "Mod+Shift+K".action.focus-monitor-up = [ ];
    "Mod+Shift+Down".action.focus-monitor-down = [ ];
    "Mod+Shift+J".action.focus-monitor-down = [ ];

    "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
    "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
    "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
    "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];
    "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
    "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
    "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
    "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];

    "Mod+Page_Down".action.focus-workspace-down = [ ];
    "Mod+Page_Up".action.focus-workspace-up = [ ];
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
    "Mod+Shift+Page_Down".action.move-window-to-workspace-down = [ ];
    "Mod+Shift+Page_Up".action.move-window-to-workspace-up = [ ];

    "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
    "Mod+WheelScrollUp".action.focus-workspace-up = [ ];
    "Mod+Ctrl+WheelScrollDown".action.move-column-to-workspace-down = [ ];
    "Mod+Ctrl+WheelScrollUp".action.move-column-to-workspace-up = [ ];

    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;

    "Mod+Ctrl+1".action.move-column-to-workspace = 1;
    "Mod+Ctrl+2".action.move-column-to-workspace = 2;
    "Mod+Ctrl+3".action.move-column-to-workspace = 3;
    "Mod+Ctrl+4".action.move-column-to-workspace = 4;
    "Mod+Ctrl+5".action.move-column-to-workspace = 5;
    "Mod+Ctrl+6".action.move-column-to-workspace = 6;
    "Mod+Ctrl+7".action.move-column-to-workspace = 7;
    "Mod+Ctrl+8".action.move-column-to-workspace = 8;
    "Mod+Ctrl+9".action.move-column-to-workspace = 9;

    "Mod+Shift+1".action.move-window-to-workspace = 1;
    "Mod+Shift+2".action.move-window-to-workspace = 2;
    "Mod+Shift+3".action.move-window-to-workspace = 3;
    "Mod+Shift+4".action.move-window-to-workspace = 4;
    "Mod+Shift+5".action.move-window-to-workspace = 5;
    "Mod+Shift+6".action.move-window-to-workspace = 6;
    "Mod+Shift+7".action.move-window-to-workspace = 7;
    "Mod+Shift+8".action.move-window-to-workspace = 8;
    "Mod+Shift+9".action.move-window-to-workspace = 9;

    "Mod+R".action.switch-preset-column-width = [ ];
    "Mod+Shift+R".action.reset-window-height = [ ];
    "Mod+F".action.maximize-column = [ ];
    "Mod+Shift+F".action.fullscreen-window = [ ];
    "Mod+C".action.center-column = [ ];

    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";
    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    "Mod+Q" = {
      action = close-window;
      repeat = false;
    };
    "Mod+Shift+E".action.quit = [ ];
    "Mod+Shift+P".action.power-off-monitors = [ ];
  };
}
