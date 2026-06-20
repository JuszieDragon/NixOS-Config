{ config, lib, pkgs, ... }: with builtins; {
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
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = config.gtk.theme;
    };
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
      gestures.hot-corners.enable = false;
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
      spawn-at-startup = [
        { sh = "noctalia"; }
        { sh = "workspace-backgrounds"; }
        { sh = "niri msg action focus-workspace ${toString (length (attrNames config.programs.niri.settings.workspaces) + 1)}"; }
      ];
    };
  };
}
