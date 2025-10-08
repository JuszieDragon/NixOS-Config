# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /git.nix
    #/komga.nix
    #/nixarr.nix
    /podman.nix
    #/qbittorrent.nix
    /vscode-server.nix
    /zfs.nix
  ];

  containerImports = map (container: containersRoot + container) [
    #/openspeedtest.nix
    #/sonarr-anime.nix
  ];

in {
  #https://nixos.org/manual/nixos/stable/index.html#sec-replace-modules
  #disabledModules = [ "services/torrent/qbittorrent.nix" ];
  
  imports = [ 
    ./hardware-configuration.nix
    #"${inputs.my-nixpkgs}/nixos/modules/services/torrent/qbittorrent.nix"
  ] ++ moduleImports ++ containerImports;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };

  networking = {
    hostId = "c97a8d58";
    hostName = "soul-matrix";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Hobart/Australia";

  users.users.justin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    neovim
    gh
    git
    tmux
    lazygit
    vimPlugins.LazyVim
  ];

  services.openssh.enable = true;
  
  age.identityPaths = [ "/home/justin/.ssh/id_ed25519" ];

  system.stateVersion = "25.05"; # Did you read the comment?
}

