{ catalog, pkgs, ... }:
let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
  ];

  serviceImports = catalog.servicePathsForHost;
  containerImports = catalog.containerPathsForHost;

in {
  imports = [
    ./disko.nix
    ../default.nix
  ] ++ modulesImports ++ serviceImports ++ containerImports;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;

    kernelParams = [
      "console=ttyS2,1500000n8"
      "console=ttyFIQ0,1500000n8"
      "console=tty0"
      "earlycon=uart8250,mmio32,0xfeb50000"
    ];

    initrd = {
      includeDefaultModules = true;
      availableKernelModules = [
        "nvme"
        "phy_rockchip_naneng_combphy"
      ];
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "mementos";
    firewall.enable = false;
    networkmanager.enable = true;
  };

  system.stateVersion = "26.11";
}
