{ inputs, pkgs, ... }: {
  hardware.sane.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = false;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
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
  # sets high scheduling priority for pipewire audio threads
  security.rtkit.enable = true;

  environment = {
    # https://discourse.nixos.org/t/hyprland-dolphin-file-manager-trying-to-open-an-image-asks-for-a-program-to-use-for-open-it/69824/3
    etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      foliate
      git
      gnome-disk-utility
      localsend
      usbutils
      mpv
      neovim
      orca-slicer
      pulseaudio
      qimgv
      restic
      restic-browser
      simple-scan
      swaybg
      unrar
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

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
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
  };
}
