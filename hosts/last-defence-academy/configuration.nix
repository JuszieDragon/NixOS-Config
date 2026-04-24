{ catalog, pkgs, ... }:

let
  serviceImports = catalog.servicePathsForHost;
  containerImports = catalog.containerPathsForHost;

in {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ] ++ serviceImports ++ containerImports;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "last-defence-academy";
    firewall.enable = false;
    networkmanager.enable = true;
    interfaces.enp3s0.wakeOnLan.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  
  system.stateVersion = "25.11"; # Did you read the comment?
}

