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
    niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };
    uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed cleanly by UWSM";
          binPath = "/run/current-system/sw/bin/niri";
          extraArgs = [ "--session" ];
        };
      };
    };
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
    displayManager = {
      noctalia-greeter.enable = true;
      # Stop the non-uwsm version of Niri from showing in the greeter
      sessionPackages = lib.mkForce [ ];
    };
    gnome.gnome-keyring.enable = true;
    dbus.packages = with pkgs; [ gnome-keyring gcr_4 ];
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

