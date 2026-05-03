{ inputs, pkgs, ... }: {
  imports = [
    ./zsh.nix

    inputs.lazyvim.homeManagerModules.default
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
    lazyvim = {
      enable = true;
      extras.lang.nix.enable = true;
      extraPackages = with pkgs; [
        nixd
        ripgrep
        fd
        fzf
      ];
      treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        nix
      ];
      config.options = #lua 
      ''
        vim.opt.relativenumber = false
      '';
      plugins = {
        colorscheme = #lua
        ''
          return {
            { "ellisonleao/gruvbox.nvim" },
            {
              "LazyVim/LazyVim",
              opts = {
                colorscheme = "gruvbox",
              },
            }
          }
        '';
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

