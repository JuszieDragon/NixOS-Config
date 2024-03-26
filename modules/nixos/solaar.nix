{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    solaar
    gnomeExtensions.solaar-extension
  ];

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}