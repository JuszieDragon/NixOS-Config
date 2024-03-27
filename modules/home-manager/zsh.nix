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
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cpk = "cat /etc/current-system-packages";
      nixosbuild = "sudo nixos-rebuild switch --flake ~/nixos#default";
      webbuildandload = "web-ext build -n a2o4.xpi && firefox-devedition web-ext-artifacts/a2o4.xpi";
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
