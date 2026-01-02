# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  modulesRoot = ../../modules/nixos;
  
  modulesImports = map (module: modulesRoot + module) [
    /feishin.nix
    /gaming.nix
  ];

in {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ] ++ modulesImports;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    firewall.enable = false;
    hostName = "revachol";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
    printing.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    udisks2.enable = true;
  };

  programs = {
    niri.enable = true;
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    git
    usbutils
    mpv
    neovim
    orca-slicer
    pulseaudio
    qimgv
    swaybg
    swaylock
    unrar
    wget
    vesktop
    xwayland-satellite

    kdePackages.ark
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
  ];

  #xdg.portal = with pkgs; {
  #  enable = true;
  #  xdgOpenUsePortal = true;
  #  extraPortals = [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  #  configPackages = [ xdg-desktop-portal-gtk ];
  #  config.common.default = "gtk";
  #};

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

