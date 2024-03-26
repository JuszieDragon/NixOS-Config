{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    sqlite
    python312
    poetry
  ];

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        kamadorueda.alejandra
        jnoortheen.nix-ide
        bungcip.better-toml
        cweijan.vscode-database-client2
        #ms-vscode-remote.remote-ssh
      ];
      userSettings = {
        #font for zsh in the terminal
        "terminal.integrated.fontFamily" = "MesloLGS NF";
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "database-client.telemetry.usesOnlineServices" = false;
      };
    };
  };
}
