{ config, inputs, pkgs, ... }: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/niri
  ];

  home.packages = with pkgs; [
    wlr-randr
  ];
}
