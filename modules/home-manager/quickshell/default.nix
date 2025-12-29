{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    quickshell
  ];

  xdg = {
    enable = true;
    configFile."quickshell/shell.qml".source = ./shell.qml;
  };
}
