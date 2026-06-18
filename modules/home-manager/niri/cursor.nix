{ config, pkgs, ... }: {
  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        inherit name;
        size = 64;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${pkgs.fetchzip {
            inherit url hash;
            stripRoot = false;
          }} $out/share/icons/${name}
        '';
      };
    in
      getFrom
    "http://192.168.1.1:8085/cursors/Pixloen-Nice-Nature.tar.gz"
    "sha256-aqcKS5FGPBOW2dH4A8uM++HHwdlTEOoqFi9FyuIFmCM="
    "Nice-Nature";
  programs.niri.settings.cursor = {
    hide-after-inactive-ms = 5000;
  };
}
