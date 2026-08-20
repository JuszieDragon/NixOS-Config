{ inputs, pkgs, ... }: {
  imports = [
    ./lazyvim.nix
    ./zsh
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
      inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      jq
      lazygit
      nixd
      nerd-fonts.jetbrains-mono
      nurl
      pciutils
      (sqlit-tui.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [ python3Packages.pytz ];
      }))
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
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "a";
      terminal = "tmux-256color";
      extraConfig = ''
        set -ga terminal-overrides ",*:RGB"
        set -g mouse on
        set -g set-clipboard on

        # Split windows
        unbind %
        unbind '"'
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"

        # Shift+arrows to switch windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Alt+number to select windows
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9

        # Statusline - current window
        set -g window-status-current-format "#I: (✓) #(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev)"

        # Statusline - other windows
        set -g window-status-format "#I: #W"
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
        terminal = {
          shell = "${pkgs.zsh}/bin/zsh";
          osc52 = "CopyPaste";
        };
      };
    };
  };
}

