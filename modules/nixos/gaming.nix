{
  pkgs,
  ...
}: let

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
    gamescope
    gpu-screen-recorder
    #itch #currently has a broken dependency
    libnotify
    libsecret
    lutris
    mangohud
    protontricks
    protonup-rs
    protonplus
  ];

  hardware = {
    xone.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    enableRedistributableFirmware = true;
  };

  programs = {
    steam = {
      enable = true;
      # Fix crashing until pipewire is restarted
      package = pkgs.steam.override {
        extraEnv = {
          SDL_AUDIODRIVER = "pipewire";
        };
      };
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
}
