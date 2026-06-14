{ pkgs, ... }: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/niri
    ../../modules/home-manager/noctalia
    ../../modules/home-manager/quickshell
    ../../modules/home-manager/steam.nix
  ];

  home.packages = with pkgs; [
    wlr-randr
    (
      pkgs.writers.writePython3Bin "workspace-backgrounds" {} (
        builtins.readFile ../../modules/home-manager/niri/workspace-backgrounds.py
      )
    )
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
