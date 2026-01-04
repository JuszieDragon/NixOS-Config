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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    sane.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    udisks2.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  };

  programs = {
    niri.enable = true;
    firefox.enable = true;
  };

  environment = {
    # https://discourse.nixos.org/t/hyprland-dolphin-file-manager-trying-to-open-an-image-asks-for-a-program-to-use-for-open-it/69824/3
    etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      alacritty
      fuzzel
      git
      gnome-disk-utility
      usbutils
      mpv
      neovim
      orca-slicer
      pulseaudio
      qimgv
      simple-scan
      swaybg
      swaylock
      unrar
      wget
      vesktop
      xwayland-satellite

      kdePackages.ark
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.qtsvg
      kdePackages.baloo-widgets
      kdePackages.baloo
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kservice

      libreoffice-qt
      hunspell
      hunspellDicts.en_AU-large
    ];
  };

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

