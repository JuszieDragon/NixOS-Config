{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "eden";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For VA-API (Broadwell or newer)
      libvdpau-va-gl
    ];
  };

  services = {
    printing.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    libinput.enable = true;
  };

  programs = {
    niri.enable = true;
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    fuzzel
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

