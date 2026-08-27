{ catalog, config, inputs, pkgs, ... }:

let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
    /desktop.nix
    /feishin.nix
    /gaming.nix
    /webhook.nix
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
    #Related to USB PD, should be fine to disable to remove error in logs on boot
    blacklistedKernelModules = [ "ucsi_acpi" "r8169" ];
    extraModulePackages = [ config.boot.kernelPackages.r8125 ];
    kernelModules = [ "r8125" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "pcie_aspm=off" "r8125.aspm=0" "pcie_aspm=off" ];
  };

  powerManagement.scsiLinkPolicy = "max_performance";

  networking = {
    firewall.enable = false;
    hostName = "revachol";
    networkmanager = {
      enable = true;
      settings = {
        device = {
          "wifi.scan-rand-mac-address" = "no";
          "ethernet.properties" = "eee=0";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs.rocmPackages; [
        clr
        clr.icd
        hipblas
        rocblas
      ];
    };
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "niri-session"; # or your specific compositor command
          user = "justin";
        };
        default_session = {
          command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter"; 
          user = "greeter";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver.videoDrivers = [ "amdgpu" ];
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm; # Uses the ROCm build of Ollama
      # Force RDNA3 architecture identification for the 7900 XTX
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
      rocmOverrideGfx = "11.0.0";
    };
  };

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    faugus-launcher
    hydrus
    prismlauncher

    aider-chat
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
