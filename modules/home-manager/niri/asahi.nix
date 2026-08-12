{
  programs.niri.settings = {
    input.touchpad = {
      tap = false;
      click-method = "clickfinger";
      #TODO play with this more, scroll speed seems to be good in chromium apps, but way too slow in terminal
      scroll-factor = 0.5;
    };
    debug.render-drm-device = "/dev/dri/renderD128";
  };
}
