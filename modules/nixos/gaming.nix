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
    protonup-rs
    protontricks
    gamescope
    gamemode
    mangohud
    gpu-screen-recorder
    libnotify
    #itch #currently has a broken dependency
  ];

  hardware.xone.enable = true;

  programs = {
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
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

  #xdg.mime = {
  #  enable = true;
  #  addedAssociations = {
  #    "x-scheme-handler/r2" = ["reloaded-ii-url.desktop"];
  #  };
  #};

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

