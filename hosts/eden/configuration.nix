{ config, inputs, lib, pkgs, ... }:
let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
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

  environment = {
    # https://discourse.nixos.org/t/hyprland-dolphin-file-manager-trying-to-open-an-image-asks-for-a-program-to-use-for-open-it/69824/3
    etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      brightnessctl
      chromium
      distrobox
      foliate
      git
      gnome-disk-utility
      hydrus
      localsend
      usbutils
      mpv
      neovim
      orca-slicer
      prismlauncher
      pulseaudio
      qimgv
      restic
      restic-browser
      simple-scan
      swaybg
      swaylock
      unrar
      wget
      wiremix
      vesktop
      vulkan-tools
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

      glfw
      openal
      libglvnd
      mesa

      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  programs = {
    noctalia-greeter.enable = true;
    niri.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [ "gnome" "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = "gtk";

        #fix discord screensharing with niri
        "org.freedesktop.portal.ScreenCast" = "gnome";
        "org.freedesktop.portal.Screenshot" = "gnome";
      };
    };
  };

  services = {
    openssh.enable = true;
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

