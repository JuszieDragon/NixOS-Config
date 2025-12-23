{ lib, pkgs, ... }: {
  imports = [
    ./binds.nix
    ./cursor.nix
    ./input.nix
    ./layout.nix
    ./outputs.nix
  ];

  programs.niri = {
    settings = {
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
    };
  };
}
