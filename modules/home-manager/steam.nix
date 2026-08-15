{ inputs, lib, pkgs, ... }:
let
  customProtonGEVersion = pVersion: pHash:
    ( pkgs.proton-ge-bin.overrideAttrs rec {
      version = pVersion;
      src = pkgs.fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        hash = pHash;
      };
    }).override { steamDisplayName = pVersion; };

  customDWProtonVersion = pVersion: pHash: (
    pkgs.dwproton-bin.overrideAttrs rec {
      version = pVersion;
      src = pkgs.fetchzip {
        url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${version}/${version}-x86_64.tar.xz";
        hash = pHash;
      };
  }).override { steamDisplayName = pVersion; };

  fetchFromNas = filename: hash:
    pkgs.fetchurl {
      url = "http://192.168.1.1:8085/SteamGridDB/${filename}";
      inherit hash;
    };

  buildArtwork = game: artworks:
    builtins.mapAttrs (name: value: fetchFromNas "${game}/${name}.png" artworks.${name}) artworks;
in {
  imports = [ inputs.steam-config-nix.homeModules.default ];

  programs.steam.config = {
    enable = true;
    onSteamRunning = "close";

    apps = {
      Satisfactory = {
        id = 526870;
        compatTool = customProtonGEVersion "GE-Proton11-3" "sha256-RiCmnUKeZRhPUCgm7fsROKFkAl37+/tYkA47tQtkIF4=";
        rawLaunchOptions = "LD_PRELOAD=\"\" gamescope -f -w 3440 -h 1440 -W 3440 -H 1440 --force-grab-cursor -- %command%";
      };
      #Fix audio with native linux build
      Scarlet-Hollow = {
        id = 1609230;
        rawLaunchOptions = "SDL_AUDIODRIVER=pulse %command%";
      };
      # Native linux version doesn't detect mouse, might be niri related
      Tabletop-Simulator = {
        id = 286160;
        compatTool = "proton_experimental";
      };
      Umamusume-Pretty-Derby = {
        id = 3224770;
        compatTool = customProtonGEVersion "GE-Proton10-3" "sha256-V4znOni53KMZ0rs7O7TuBst5kDSaEOyWUGgL7EESVAU=";
      };
    };
    nonSteamApps = {
      "Goddess of Victory: NIKKE" = {
        target = "/home/justin/Games/Lutris/Nikke/drive_c/NIKKE/Launcher/nikke_launcher.exe";
        startIn = "/home/justin/Games/Lutris/Nikke";
        compatTool = customDWProtonVersion "dwproton-11.0-5" "sha256-2x4xotJ2aJYbg+G2TDPqyU7uuoc/hZQon9CA6SFGin0=";
        allowOverlay = false;
        artwork = buildArtwork "Nikke" {
          cover = "sha256-eXLkEqwvQPcSmexQWfAomYRJhL4dHNas0dygk07PIXY=";
          header = "sha256-dMf4z/PYLV1jFt95VdcT9Ju10kdTmhXvF9ljnLlcoMA=";
          hero = "sha256-laf/AlJzoueQ5ceOKHatlZeyNJMWsy7eFfZMGexR5Xg=";
          logo = "sha256-DDXSVmjPI9tE4cPL9G3MOQ3158tg/6I8oxPQZQjd9bg=";
          icon = "sha256-VIRL00ZrMMq4dRWdTAQQn6Khik6Z8cJ797/wugWhCVI=";
        };
      };
      "Katawa Shoujo: Re-Engineered" = {
        target = pkgs.katawa-shoujo-re-engineered;
        artwork = buildArtwork "Katawa_Shoujo_Re-Engineered" {
          cover = "sha256-XnOi9YEUsvU0RBRu02YbgRQrEJhVue6yI3t8iVv0npo=";
          header = "sha256-/3ebfa83n8RwvvNv9RtibRokHy7zQD+hDcKOAnTBHEo=";
          hero = "sha256-TxvCHvggRyZuFl6kPhrSp85oFMVY2Ilh2x3UYK0sEJM=";
          logo = "sha256-FsobjwJzqwWFSAi2DDwh7csaiwj7pcX8/gD4AVmhxsE=";
          icon = "sha256-6ZDOXAQAP/JiJY2Zl5MVccfGj/sHRzjMadGz/p5eLqA=";
        };
      };
    };
  };
}
