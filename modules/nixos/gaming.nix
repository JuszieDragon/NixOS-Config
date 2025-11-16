{
  config,
  pkgs,
  ...
}: let
  reloadedDesktopItem = pkgs.makeDesktopItem {
    name = "Reloaded-II URL Handler";
    exec = "protontricks-launch --appid 2161700 /home/justin/Modding/Persona/Reloaded-II.exe --download %U";
    icon = "applications-games";
    startupNotify = false;
    terminal = "false";
    mimetypes = ["x-scheme-handler/r2"];
  };
in {
  environment.systemPackages = with pkgs; [
    steam
    protonup-qt
    protontricks
    gamescope
    gamemode
    steamtinkerlaunch
    # https://github.com/sonic2kk/steamtinkerlaunch/wiki
    # need to run `steamtinkerlaunch compat add` to make appear in steam
    # other setup info here https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
    mangohud # to enable with steamtinkerlaunch goto Game Menu (on the bottom) and scroll to Tool Options
    gpu-screen-recorder
    libnotify
    bottles
    #itch #currently has a broken dependency
  ];

  hardware.xone.enable = true;

  programs = {
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      #gamescopeSession.enable = true;
    };
    #mangohud = {

    #}
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };
  };

  xdg.mime = {
    enable = true;
    addedAssociations = {
      "x-scheme-handler/r2" = ["reloaded-ii-url.desktop"];
    };
  };

  #might be able to setup reloaded one click with this
  /*
  xdg.mimeApps.defaultApplications = {
  "text/html" = [ "firefox.desktop" ];
  "text/xml" = [ "firefox.desktop" ];
  "x-scheme-handler/http" = [ "firefox.desktop" ];
  "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
  */
}

