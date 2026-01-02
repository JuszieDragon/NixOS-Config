{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    quickshell
    lm_sensors
  ];

  xdg = {
    enable = true;
    configFile."quickshell/shell.qml".source = ./shell.qml;
  };
}
