{
  config,
  lib,
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

  customProtonGEVersion = pVersion: pHash:
    ( pkgs.proton-ge-bin.overrideAttrs rec { 
      version = pVersion;
      src = pkgs.fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        hash = pHash;
      };
    }).override { steamDisplayName = pVersion; };
in {
  environment.systemPackages = with pkgs; [
    protonup-rs
    protontricks
    gamescope
    mangohud
    gpu-screen-recorder
    libnotify
    #itch #currently has a broken dependency
  ];

  hardware = {
    #xone.enable = true;
    enableRedistributableFirmware = true;
  };

  programs = {
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [
        ( customProtonGEVersion "GE-Proton10-3" "sha256-V4znOni53KMZ0rs7O7TuBst5kDSaEOyWUGgL7EESVAU=" )
      ];
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

