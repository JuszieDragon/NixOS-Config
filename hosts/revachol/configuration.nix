{ inputs, pkgs, ... }:

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
    #Related to USB PD, should be fine to disable to remove error in logs on boot
    blacklistedKernelModules = [ "ucsi_acpi" ];
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
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    sane.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    getty.autologinUser = "justin";
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    udisks2.enable = true;
    # To build crosspoint
    udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];
    xserver.videoDrivers = [ "amdgpu" ];
  };

  programs.niri.enable = true;

  environment = {
    # https://discourse.nixos.org/t/hyprland-dolphin-file-manager-trying-to-open-an-image-asks-for-a-program-to-use-for-open-it/69824/3
    etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      fuzzel
      git
      gnome-disk-utility
      hydrus
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
      wiremix
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

      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  xdg.portal = with pkgs; {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    configPackages = [ xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
    wlr.enable = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}

