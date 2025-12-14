{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "last-defence-academy";
    firewall.enable = false;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  
  system.stateVersion = "25.11"; # Did you read the comment?
}

