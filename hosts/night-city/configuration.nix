{ config, lib, pkgs, inputs, ... }:

let
  modulesRoot = ../../modules/nixos;
  containersRoot = ../../containers;

  moduleImports = map (module: modulesRoot + module) [
    /caddy.nix
    /git.nix
    /podman.nix
    /shares.nix
    /unifi.nix
    /vscode-server.nix
  ];

  containerImports = map (container: containersRoot + container) [
    /openspeedtest.nix
    /romm.nix
  ];

  wrapAlias = command: "f() { " + command + "; unset -f f; }; f";

in {
  imports = [ 
    ./hardware-configuration.nix
    ../default.nix
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

  users = {
    groups = { home-lab = { }; };
    users.justin = {
      extraGroups = [ "wheel" "docker" "server" "home-lab" "media" ];
    };
  };

  environment.systemPackages = with pkgs; [
    temurin-jre-bin
    nixfmt-rfc-style
    steamcmd
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

