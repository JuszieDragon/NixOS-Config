{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        height = 20;
        layer = "top";
        modules-left = [];
        modules-center = ["clock"];
        modules-right = ["tray"];
      };

      "clock" = {
        format = "{%a %o %b %r}";
      };
      "tray" = {
        spacing = 30;
      };
    };
  };
}
