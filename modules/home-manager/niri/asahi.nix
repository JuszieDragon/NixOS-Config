{
  programs.niri.settings = {
    input.touchpad = {
      tap = false;
      dwt = true;
      click-method = "clickfinger";
      #TODO play with this more, scroll speed seems to be good in chromium apps, but way too slow in terminal
      scroll-factor = 0.1;
    };
    debug.render-drm-device = "/dev/dri/renderD128";
  };
}
