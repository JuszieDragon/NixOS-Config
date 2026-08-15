{ config, inputs, lib, pkgs, ... }:
let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
    /desktop.nix
    /feishin.nix
  ];

in {
  imports = [
    ./hardware-configuration.nix
    ./shares.nix
    ../default.nix
  ] ++ modulesImports;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  hardware = {
    asahi = {
      enable = true;
      peripheralFirmwareDirectory = inputs.self + /firmware;
    };
    bluetooth.enable = true;
    graphics.enable = true;
  };

  networking = {
    hostName = "eden";
    firewall.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    chromium
    foliate
    prismlauncher

    vulkan-tools
    glfw
    openal
    libglvnd
    mesa
  ];

  programs = {
    noctalia-greeter.enable = true;
    niri.enable = true;
    steam-asahi.enable = true;
  };

  users = {
    # cleanup logs for steam-asahi
    groups.plugdev = {};
    users.justin.extraGroups = [
      "kvm"
      "video"
      "render"
    ];
  };

  services = {
    getty.autologinUser = "justin";
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    libinput.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  system.stateVersion = "26.11"; # Did you read the comment?
}

