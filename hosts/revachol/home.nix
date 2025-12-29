{ config, inputs, pkgs, ... }: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/niri
    ../../modules/home-manager/quickshell
    ../../modules/home-manager/steam.nix
  ];

  home.packages = with pkgs; [
    wlr-randr
  ];
}
