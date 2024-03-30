{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  programs.waybar.package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;

  environment.systemPackages = with pkgs; [
    mako
    libnotify
    hyprpaper
    hyprlock
    hyprshot
    #hyprcursor # needs unstable
    waybar
    alacritty
    rofi-wayland
    playerctl
  ];
}
