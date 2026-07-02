{ config, pkgs, ... }:
let
  my-uid = toString config.users.users.justin.uid;

  env-vars = /*bash*/ ''
    export WAYLAND_DISPLAY=wayland-0
    export XDG_RUNTIME_DIR=/run/user/${my-uid}
    export PULSE_RUNTIME_DIR=/run/user/${my-uid}
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${my-uid}/bus

    export NIRI_SOCKET=$(${pkgs.findutils}/bin/find /run/user/1000/ -name "niri*" -type s 2>/dev/null | head -n 1)
  '';

  lounge-mode = pkgs.writeShellScriptBin "lounge-mode" ''
    ${env-vars}

    if [ -z "$NIRI_SOCKET" ]; then
      ${pkgs.niri}/bin/niri-session
      sleep 5
    fi

    ${pkgs.niri}/bin/niri msg output HDMI-A-1 on
    ${pkgs.niri}/bin/niri msg output DP-1 off
    ${pkgs.niri}/bin/niri msg output DP-2 off
    ${pkgs.niri}/bin/niri msg output DP-3 off

    for i in {1..5}; do
      if ! ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.pci-0000_03_00.1.hdmi-surround-extra3; then
        echo "Failed to swap to tv audio, retrying in 10 seconds"
        sleep 10
      else
        break
      fi
    done
  '';

  main-mode = pkgs.writeShellScriptBin "main-mode" ''
    ${env-vars}

    if [ -z "$NIRI_SOCKET" ]; then
      ${pkgs.niri}/bin/niri-session
    else
      ${pkgs.niri}/bin/niri msg output HDMI-A-1 off
      ${pkgs.niri}/bin/niri msg output DP-1 on
      ${pkgs.niri}/bin/niri msg output DP-2 on
      ${pkgs.niri}/bin/niri msg output DP-3 on
    fi

    ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.usb-SteelSeries_Arctis_Pro_Wireless-00.stereo-game
  '';
  lounge-gamescope-mode = pkgs.writeShellScriptBin "lounge-gamescope-mode" ''
    ${pkgs.playerctl}/bin/playerctl pause

    /run/wrappers/bin/sudo ${pkgs.kbd}/bin/chvt 3
  '';
in
{
  programs.gamescope.enable = true;

  home-manager.users.justin = _: {
    programs.zsh.loginExtra = /*bash*/ ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty3" ]; then
        pactl set-default-sink alsa_output.pci-0000_03_00.1.hdmi-surround-extra3
        GAMESCOPE_COLOR_SPACE=bt2020 AMD_DEBUG=force_10bit gamescope --hdr-enabled -O HDMI-A-1 -w 3840 -h 2160 -e -- steam -steamdeck -steamos3
      fi
    '';
  };

  services.webhook = {
    enable = true;
    user = "justin";
    group = "users";
    openFirewall = true;
    hooks = {
      ${lounge-mode.name}.execute-command = "${lounge-mode}/bin/${lounge-mode.name}";
      ${main-mode.name}.execute-command = "${main-mode}/bin/${main-mode.name}";
      ${lounge-gamescope-mode.name}.execute-command = "${lounge-gamescope-mode}/bin/${lounge-gamescope-mode.name}";
    };
  };

  users.users.justin.extraGroups = [ "tty" "video" "input" "render" ];

  security.sudo.extraRules = [
    {
      users = [ "justin" ];
      commands = [
        {
          command = "${pkgs.kbd}/bin/chvt";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}

