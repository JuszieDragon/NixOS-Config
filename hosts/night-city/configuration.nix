# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let 
  modulesRoot = ./../../modules/nixos;

  moduleImports = map (module: modulesRoot + module) [
    /shares.nix
    /vscode-server.nix
    /caddy.nix
    /nixarr.nix
    /git.nix
    /unifi.nix
  ];

in {
  imports = [ ./hardware-configuration.nix ] ++ moduleImports;

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "night-city"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Australia/Hobart";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.groups = {
    home-lab = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justinj0 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "server" "home-lab" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild -I nixos-config=/home/justinj0/NixOS-Config/hosts/nixos-server/configuration.nix switch";
    nconf = "nvim ~/NixOS-Config/hosts/nixos-server/configuration.nix";
    lg = "lazygit";
    
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  ];

  virtualisation.docker.enable = true;

  modules.caddy.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

