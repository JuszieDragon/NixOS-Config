{ config, lib, pkgs, inputs, ... }:

let
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /caddy.nix
    /git.nix
    /komga.nix
    /nixarr.nix
    /podman.nix
    /qbittorrent.nix
    /shares.nix
    /tt-rss.nix
    /unifi.nix
    /vscode-server.nix
  ];

  containerImports = map (container: containersRoot + container) [
    /openspeedtest.nix
    /romm.nix
    /sonarr-anime.nix
  ];

  wrapAlias = command: "f() { " + command + "; unset -f f; }; f";

in {
  #https://nixos.org/manual/nixos/stable/index.html#sec-replace-modules
  disabledModules = [ "services/torrent/qbittorrent.nix" ];
  
  imports = [ 
    ./hardware-configuration.nix
    "${inputs.my-nixpkgs}/nixos/modules/services/torrent/qbittorrent.nix" 
  ] ++ moduleImports ++ containerImports;

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/sda";
  };

  networking = {
    hostName = "night-city";
    #TODO do actual networking
    firewall.enable = false;
  };

  time.timeZone = "Australia/Hobart";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users = {
    groups = { home-lab = { }; };
    users.justinj0 = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "server" "home-lab" "media" ];
      packages = with pkgs; [ tree ];
    };
  };

  programs = {
    tmux.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    bash.shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake";
      nconf = "nvim /home/justinj0/nixos-config/hosts/nixos-server/configuration.nix";
      lg = "lazygit";
      jctl = wrapAlias "sudo journalctl -u $1.service -b 0";
      jctlc = wrapAlias "sudo journalctl -u podman-$1.service -b 0";
      agee = wrapAlias "agenix -e $1 -i /home/justinj0/.ssh/id_ed25519";

      tnmoni = "tmux new -s monifactory 'cd /srv/minecraft/Monifactory && ./run.sh'";
      tamoni = "tmux attach -t monifactory";
      tndepth = "tmux new -s depth 'cd /srv/minecraft/Beyond-Depth && ./run.sh'";
      tadepth = "tmux attach -t depth";
      tnminebot = "tmux new -s minebot 'nix-shell /home/justinj0/Projects/Mine-Bot/shell.nix --run \"python3 /home/justinj0/Projects/Mine-Bot/main.py\"'";
      taminebot = "tmux attach -t minebot";
      tna2o4 = "tmux new -s a2o4 '/home/justinj0/Projects/A2O4-Server-RS/target/release/a2o4-server'";
      taa2o4 = "tmux attach -t a2o4";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    unzip
    zip
    lazygit
    temurin-jre-bin
    btop
    nixd
    jq
    gh
    vimPlugins.LazyVim
    inputs.agenix.packages."${system}".default
    bat
    nixfmt-rfc-style
    steamcmd
  ];

  services = {
    openssh.enable = true;
  };

  age.identityPaths = [ "/home/justinj0/.ssh/id_ed25519" ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

