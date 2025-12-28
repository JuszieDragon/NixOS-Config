{ lib, pkgs, ... }: {
  imports = [
    ./binds.nix
    ./cursor.nix
    ./input.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
  ];

  programs.niri = {
    settings = {
      environment."NIXOS_OZONE_WL" = "1";
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
    };
  };
}
