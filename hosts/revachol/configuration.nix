# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  modulesRoot = ../../modules/nixos;
  
  modulesImports = map (module: modulesRoot + module) [
    /gaming.nix
  ];

in {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ] ++ modulesImports;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "revachol"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

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
    printing.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };

  programs = {
    niri.enable = true;
    firefox.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    git
    mpv
    neovim
    pulseaudio
    swaylock
    wget
    vesktop
    xwayland-satellite

    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?
}

