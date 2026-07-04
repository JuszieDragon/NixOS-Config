{ pkgs, ... }: {
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
