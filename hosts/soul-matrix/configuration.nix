{ catalog, pkgs, ... }:

let
  moduleImports = map (module: ../../modules/nixos + module) [
    /cage.nix
    /podman.nix
    /restic.nix
    #/remote-builders.nix
    /samba.nix
    /zfs.nix
  ];

  serviceImports = catalog.servicePathsForHost;
  containerImports = catalog.containerPathsForHost;

in {
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
    ../default.nix
  ] ++ moduleImports ++ serviceImports ++ containerImports;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
  };

  networking = {
    hostId = "c97a8d58";
    hostName = "soul-matrix";
    #TODO actual network security
    firewall.enable = false;
  };

  users.users.justin = {
    extraGroups = [ "wheel" "media" "file_share" "seat" "video" ];
  };

  environment = {
    systemPackages = with pkgs; [
      cage
    ];
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };

  services.seatd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}

