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
    noctalia-greeter.enable = true;
    niri.enable = true;
    steam-asahi = {
      enable = true;
      backend = "arm64";
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        python3
        zlib                  # Fixes your current libz.so.1 error
        stdenv.cc.cc.lib      # Provides libstdc++.so for C++ applications
        glib                  # Common dependency for desktop app integrations
        xorg.libX11           # Useful if graphical helpers fail
      ];
    };
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

