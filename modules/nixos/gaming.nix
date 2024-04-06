{
  config,
  pkgs,
  ...
}: {
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

  #hardware.xone.enable = true;
}
