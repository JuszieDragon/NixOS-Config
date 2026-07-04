{ inputs, pkgs, ... }:
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
in {
  imports = [ inputs.steam-config-nix.homeModules.default ];

  programs.steam.config = {
    enable = true;
    onSteamRunning = "close";

    apps = {
      Umamusume-Pretty-Derby = {
        id = 3224770;
        compatTool = customProtonGEVersion "GE-Proton10-3" "sha256-V4znOni53KMZ0rs7O7TuBst5kDSaEOyWUGgL7EESVAU=";
      };
      # Native linux version doesn't detect mouse, might be niri related
      Tabletop-Simulator = {
        id = 286160;
        compatTool = "proton_experimental";
      };
    };
  };
}
