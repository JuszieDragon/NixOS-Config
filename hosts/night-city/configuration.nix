{ config, lib, pkgs, inputs, ... }:

let 
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /caddy.nix
    /git.nix
    /nixarr.nix
    /podman.nix
    /shares.nix
    /tt-rss.nix
    /unifi.nix
    /vscode-server.nix
  ];

  containerImports = map (container: containersRoot + container) [
    /openspeedtest.nix
    /romm.nix
  ];

  wrapAlias = command: ''f() { '' + command + ''; unset -f f; }; f'';

in {
  imports = [ ./hardware-configuration.nix ] ++ moduleImports ++ containerImports;

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "night-city"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Australia/Hobart";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.groups = {
    home-lab = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justinj0 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "server" "home-lab" "media" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake";
    nconf = "nvim ~/NixOS-Config/hosts/nixos-server/configuration.nix";
    lg = "lazygit";
    jctl = wrapAlias "sudo journalctl -u $1 -b 0";
    agee = wrapAlias "agenix -e $1 -i ~/.ssh/id_ed25519";
    
    tnmoni = "tmux new -s monifactory 'cd /srv/minecraft/Monifactory && ./run.sh'";
    tamoni = "tmux attach -t monifactory";
    tndepth = "tmux new -s depth 'cd /srv/minecraft/Beyond-Depth && ./run.sh'";
    tadepth = "tmux attach -t depth";
    tnminebot = "tmux new -s minebot 'nix-shell ~/Projects/Mine-Bot/shell.nix --run \"python3 ~/Projects/Mine-Bot/main.py\"'";
    taminebot = "tmux attach -t minebot";
    tna2o4 = "tmux new -s a2o4 '/home/justinj0/Projects/A2O4-Server-RS/target/release/a2o4-server'";
    taa2o4 = "tmux attach -t a2o4";
  };

  programs = {
    tmux.enable = true;
    neovim = {
    	enable = true;
	    defaultEditor = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    unzip
    lazygit
    temurin-jre-bin
    btop
    compose2nix
    nixd
    jq
    gh
    vimPlugins.LazyVim
    inputs.agenix.packages."${system}".default
    bat
    nixfmt
  ];

  modules.podman.enable = true;
  modules.caddy.enable = true;
  modules.openspeedtest.enable = true;
  modules.romm.enable = true;

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #TODO do actual proper networking
  networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}

