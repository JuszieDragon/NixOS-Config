{ inputs, lib, pkgs, ... }: {
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

      hunspell
      hunspellDicts.en_AU-large

      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

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
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    displayManager = {
      noctalia-greeter = {
        enable = true;
        settings = {
          output = {
            scale = 1.0;  # Prevent fractional scaling blur
          };
        };
      };
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
      jack.enable = true;
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
