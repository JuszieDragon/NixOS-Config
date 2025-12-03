{ config, lib, pkgs, inputs, ... }:

let
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /git.nix
    /komga.nix
    /nixarr.nix
    /podman.nix
    /qbittorrent.nix
    /samba.nix
    /scrutiny.nix
    /vscode-server.nix
    /yarr.nix
    /zfs.nix
  ];

  containerImports = map (container: containersRoot + container) [
    /kaneo.nix
    #/openspeedtest.nix
    /sonarr-anime.nix
    /yamtrack.nix
  ];

in {
  #https://nixos.org/manual/nixos/stable/index.html#sec-replace-modules
  disabledModules = [
    "services/torrent/qbittorrent.nix"
    "services/misc/yarr.nix"
  ];
  
  imports = [ 
    ./hardware-configuration.nix
    ../default.nix

    "${inputs.my-nixpkgs}/nixos/modules/services/torrent/qbittorrent.nix"
    "${inputs.my-nixpkgs}/nixos/modules/services/misc/yarr.nix"
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

