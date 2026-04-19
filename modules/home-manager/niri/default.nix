{ lib, pkgs, ... }: {
  imports = [
    ./binds.nix
    ./cursor.nix
    ./input.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
  ];

  # Set darkmode
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  programs.niri = {
    settings = {
      environment."NIXOS_OZONE_WL" = "1";
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
      spawn-at-startup = [
        { sh = "qs"; }
        { sh = "swaybg -i /home/justin/martinaise-skyline-expanded.jpg"; }
      ];
    };
  };
}
