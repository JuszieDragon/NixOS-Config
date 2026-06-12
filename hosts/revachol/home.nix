{ pkgs, ... }: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/niri
    ../../modules/home-manager/quickshell
    ../../modules/home-manager/steam.nix
    ../../modules/home-manager/firefox.nix
  ];

  home.packages = with pkgs; [
    wlr-randr
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries = {
      "hydrus-client" = {
        name = "hydrus-client";
        exec = "hydrus-client -d \"/home/justin/Documents/Hydrus Network/db\""; # Overridden execution flag
        icon = "hydrus-client";
        comment = "Danbooru-like image tagging and searching system for the desktop";
        terminal = false;
        type = "Application";
        categories = [ "FileTools" "Utility" ];
      };
    };
  };
}
