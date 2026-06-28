{ config, pkgs, ... }:

let
  my-uid = toString config.users.users.justin.uid;

  env-vars = #bash
    ''
    export WAYLAND_DISPLAY=wayland-0
    export XDG_RUNTIME_DIR=/run/user/${my-uid}
    export PULSE_RUNTIME_DIR=/run/user/${my-uid}
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${my-uid}/bus

    # Recursively find the active niri socket file
    NIRI_ACTIVE_SOCKET=$(${pkgs.findutils}/bin/find /run/user/1000/ -name "niri*" -type s 2>/dev/null | head -n 1)
    if [ -n "$NIRI_ACTIVE_SOCKET" ]; then
      export NIRI_SOCKET="$NIRI_ACTIVE_SOCKET"
    else
      echo "Error: Active niri socket not found in /run/user/${my-uid}/" >&2
      exit 1
    fi
  '';

  lounge-screens = pkgs.writeShellScriptBin "lounge-screens" ''
    ${env-vars}

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

  main-screens = pkgs.writeShellScriptBin "main-screens" ''
    ${env-vars}

    ${pkgs.niri}/bin/niri msg output HDMI-A-1 off
    ${pkgs.niri}/bin/niri msg output DP-1 on
    ${pkgs.niri}/bin/niri msg output DP-2 on
    ${pkgs.niri}/bin/niri msg output DP-3 on

    ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.usb-SteelSeries_Arctis_Pro_Wireless-00.stereo-game
  '';
in
{
  services.webhook = {
    enable = true;
    user = "justin";
    group = "users";
    openFirewall = true;
    hooks = {
      lounge-screens = {
        execute-command = "${lounge-screens}/bin/lounge-screens";
        command-working-directory = "/tmp";
      };
      main-screens = {
        execute-command = "${main-screens}/bin/main-screens";
        command-working-directory = "/tmp";
      };
    };
  };
}

