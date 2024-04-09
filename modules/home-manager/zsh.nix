{
  pkgs,
  inputs,
  ...
}: {
  home.sessionVariables = {
    PYTHON_AUTO_VRUN = "true";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cpk = "cat /etc/current-system-packages";
      nixosbuild = "sudo nixos-rebuild switch --flake ~/nixos#default";
      fup = "nix flake update";
      webbuildandload = "web-ext build -n a2o4.xpi --overwrite-dest && firefox-developer-edition web-ext-artifacts/a2o4.xpi";
      img = "qimgv .";
      setvol = "amixer -c S9 set 'PCM',1 69";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "python"
      ];
    };
  };
}
