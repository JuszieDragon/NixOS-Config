{ inputs, pkgs, ... }: {
  imports = [
    ./lazyvim.nix
    ./zsh.nix
  ];

  home = {
    username = "justin";
    homeDirectory = "/home/justin";
    stateVersion = "25.05";
    sessionVariables = {
      COLORTERM = "truecolor";
    };
    packages = with pkgs; [
      alacritty
      bat
      btop
      deadnix
      gh
      git
      inputs.agenix.packages."${stdenv.hostPlatform.system}".default
      inputs.sqlit.packages."${stdenv.hostPlatform.system}".default
      jq
      lazygit
      nixd
      nerd-fonts.jetbrains-mono
      nurl
      pciutils
      statix
      tmux
      tree
      unzip
      yazi
      zip
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Juszie Dragon";
        email = "justin.h.j.johnson@gmail.com";
      };
    };
    tmux = {
      enable = true;
      extraConfig = ''
        source-file ${inputs.dotfiles}/.config/tmux/tmux.conf
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
        };
        terminal.shell = "${pkgs.zsh}/bin/zsh";
      };
    };
  };
}

