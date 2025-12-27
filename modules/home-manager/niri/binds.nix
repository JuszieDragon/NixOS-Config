{ config, lib, pkgs, ... }: {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    "Mod+T" = {
      hotkey-overlay.title = "Open a Terminal: alacritty";
      action.spawn = "alacritty";
    };
    "Mod+Space" = {
      hotkey-overlay.title = "Run an Application: fuzzel";
      action.spawn = "fuzzel";
    };

    "XF86AudioRaiseVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "toggle"];
      allow-when-locked = true;
    };

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
  };
}
