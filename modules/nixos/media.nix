{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    qimgv
    plex-media-player
    vlc
  ];
}

