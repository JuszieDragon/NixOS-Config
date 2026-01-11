{ config, lib, pkgs, inputs, ... }:

let
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /caddy.nix
    /git.nix
    /kavita.nix
    /komga.nix
    /navidrome.nix
    /nixarr.nix
    /podman.nix
    /qbittorrent.nix
    /samba.nix
    /scrutiny.nix
    /yarr.nix
    /zfs.nix
  ];

  containerImports = map (container: containersRoot + container) [
    /beets-flask
    /kaneo.nix
    /openspeedtest.nix
    /sonarr-anime.nix
    /yamtrack.nix
  ];

in {
  imports = [ 
    ./hardware-configuration.nix
    ../default.nix
  ] ++ moduleImports ++ containerImports;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };

  networking = {
    hostId = "c97a8d58";
    hostName = "soul-matrix";
    #TODO actual network security
    firewall.enable = false;
  };

  users.users.justin = {
    extraGroups = [ "wheel" "media" "file_share" ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}

