{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    waybar.package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    /*
      mako = {
      enable = true;
      defaultTimeout = 5000;
    };
    */
  };

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
    lxqt.lxqt-policykit
  ];
}

