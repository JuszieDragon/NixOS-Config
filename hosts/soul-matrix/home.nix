{ config, inputs, pkgs, ... }: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/gallery-dl.nix
  ];
}
