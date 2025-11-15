{ config, dotfiles, lib, inputs, pkgs, ... }: {
  imports = [
    #./firefox.nix
    #./hyprland.nix
    #./vscode.nix
    #./waybar.nix
    ./zsh.nix
  ];
  
  home = {
    username = "justin";
    homeDirectory = "/home/justin";
    stateVersion = "25.05";
    packages = with pkgs; [
      bat
      btop
      gh
      git
      inputs.agenix.packages."${system}".default
      jq
      lazygit
      nixd
      pciutils
      tmux
      unzip
      zip
    ];
  };
  
  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Juszie Dragon";
        email = "justin.h.j.johnson@gmail.com";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraConfig = ''
        set tabstop=2 softtabstop=2 shiftwidth=2
        set expandtab
        set number ruler
        set autoindent smartindent
        syntax enable
        filetype plugin indent on
      '';
    };
    tmux.enable = true;
  };
}
