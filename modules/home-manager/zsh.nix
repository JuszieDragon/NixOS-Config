{ catalog, inputs, lib, pkgs, ... }: 
let
  wrapAlias = command: "f() { " + command + "; unset -f f; }; f";
  hostSSHAliases = lib.mapAttrs (host: attrs:
    "ssh ${attrs.ip}"
  ) catalog.hostsBase;

in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cpk = "cat /etc/current-system-packages";
      fup = "nix flake update";
      webbuildandload = "web-ext build -n a2o4.xpi --overwrite-dest && firefox-developer-edition web-ext-artifacts/a2o4.xpi";
      img = "qimgv .";
      setvol = "amixer -c S9 set 'PCM',1 69";

      rebuild = "sudo -v; nixos-rebuild switch --flake --sudo";
      rebuild-local = "rebuild --override-input my-nixpkgs ~/projects/nixpkgs";
      rebuild-droid = "nix-on-droid switch --flake ~/nixos-config";
      update = "nix flake update";
      update-dot = "nix flake update dotfiles";
      used-ports = wrapAlias "nix eval --file ~/nixos-config/catalog.nix portsUsed --arg lib 'import <nixpkgs/lib>' --argstr host $1 --json";

      lg = "lazygit";
      jctl = wrapAlias "sudo journalctl -u $1.service -b 0";
      jctlc = wrapAlias "sudo journalctl -u podman-$1.service -b 0";
      agee = wrapAlias "agenix -e $1 -i ~/.ssh/id_ed25519";
      szsh = "source ~/.zshrc";

      tnmoni = "tmux new -s monifactory 'cd /srv/minecraft/Monifactory && ./run.sh'";
      tamoni = "tmux attach -t monifactory";
      tndepth = "tmux new -s depth 'cd /srv/minecraft/Beyond-Depth && ./run.sh'";
      tadepth = "tmux attach -t depth";
      tnminebot = "tmux new -s minebot 'nix-shell ~/projects/Mine-Bot/shell.nix --run \"python3 ~/Projects/Mine-Bot/main.py\"'";
      taminebot = "tmux attach -t minebot";
      tna2o4 = "tmux new -s a2o4 '~/projects/A2O4-Server-RS/target/release/a2o4-server'";
      taa2o4 = "tmux attach -t a2o4";
      #zip each folder in current folder
      fzip = "for i in */; do zip -r \"\${i%/}.zip\" \"$i\"; done";
    } // hostSSHAliases;      
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];

      
    initContent = '' 
      source ${inputs.dotfiles}/.p10k.zsh
      
      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "\$\{(s.:.)LS_COLORS\}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    '';
      
    oh-my-zsh = {
      enable = true;
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # This handles key bindings and completion
  };
}

