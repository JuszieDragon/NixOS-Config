{ config, catalog, lib, pkgs, inputs, ... }:

let
  moduleImports = map (module: ../../modules/nixos + module) [
    #/git.nix
    /podman.nix
    /remote-builders.nix
    /samba.nix
    /zfs.nix
  ];

  serviceImports = catalog.servicePathsForHost;
  containerImports = catalog.containerPathsForHost;

in {
  imports = [ 
    ./hardware-configuration.nix
    ../default.nix
  ] ++ moduleImports ++ serviceImports ++ containerImports;

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

