{ pkgs, ... }: {
  home.packages = with pkgs; [
    yt-dlp
    ffmpeg
  ];

  programs.yt-dlp = {
    enable = true;
    settings = {
      merge-output-format = "mkv";
      add-metadata = true;
      embed-thumbnail = true;
    };
  };
}
