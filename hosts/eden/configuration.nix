{ catalog, config, inputs, lib, pkgs, ... }:
let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
    /desktop.nix
    /feishin.nix
    /wireguard.nix
  ];

  serviceImports = catalog.servicePathsForHost;

in {
  imports = [
    ./hardware-configuration.nix
    ./shares.nix
    ./syncthing.nix
    ../default.nix
  ] ++ modulesImports ++ serviceImports;

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.page-cluster" = 0;
      "vm.watermark_scale_factor" = 125; # reclaim earlier, avoid latency cliffs
      "vm.max_map_count" = 1048576; # Proton/DXVK requirement (Fedora/Arch default)
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
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
    steam-asahi = {
      enable = true;
      backend = "arm64";
    };
  };

  users = {
    # cleanup logs for steam-asahi
    groups.plugdev = {};
    users = {
      justin.extraGroups = [
        "kvm"
        "video"
        "render"
      ];
      greeter.extraGroups = [
        "render"
        "video"
      ];
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  services = {
    libinput.enable = true;
    logind = {
      enable = true;
      settings.Login = {
        HandlePowerKey = "ignore";
        HandlePowerKeyLongPress = "ignore";
        PowerKeyIgnoreInhibited = "yes";
      };
    };
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  system.stateVersion = "26.11"; # Did you read the comment?
}

