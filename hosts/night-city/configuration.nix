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
  imports = [ ./hardware-configuration.nix ] ++ moduleImports ++ containerImports;

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
    users.justin = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "server" "home-lab" "media" ];
      packages = with pkgs; [ tree ];
    };
  };

  environment.systemPackages = with pkgs; [
    temurin-jre-bin
    nixfmt-rfc-style
    steamcmd
  ];

  programs.zsh.enable = true;

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };

  age.identityPaths = [ "/home/justin/.ssh/id_ed25519" ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

