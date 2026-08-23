{ pkgs, ... }:
let
  modulesRoot = ../../modules/nixos;

  modulesImports = map (module: modulesRoot + module) [
  ];

in {
  imports = [
    ./disko.nix
    ../default.nix
  ] ++ modulesImports;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;

    kernelParams = [
      "console=ttyS2,1500000n8"
      "console=ttyFIQ0,1500000n8"
      "console=tty0"
      "earlycon=uart8250,mmio32,0xfeb50000"
      "nomodeset"
      "video=HDMI-A-1:1920x1080@60"
      "pcie_aspm=off"
      "nvme_core.default_ps_max_latency_us=0"
    ];

    initrd = {
      includeDefaultModules = true;
      availableKernelModules = [
        "usb_storage"
        "uas"
        "xhci_plat_hcd"
        "nvme"
        "pcie_rockchip_host"
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
