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

  lounge-gamescope-mode = pkgs.writeShellScriptBin "lounge-gamescope-mode" ''
    ${pkgs.playerctl}/bin/playerctl pause

    /run/wrappers/bin/sudo ${pkgs.kbd}/bin/chvt 3
  '';

  gamescope-runner = pkgs.writeShellScriptBin "gamescope-runner" ''
    if [ -f /etc/profile ]; then
      source /etc/profile
    fi

    export PATH="/run/current-system/sw/bin:/run/user/${my-uid}/bin:$PATH"
    export XDG_RUNTIME_DIR="/run/user/${my-uid}"
    export XDG_SESSION_TYPE="wayland"
    export GAMESCOPE_COLOR_SPACE="bt2020"
    export AMD_DEBUG="force_10bit"
    export SDL_VIDEODRIVER="wayland"

    sleep 1

    ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.pci-0000_03_00.1.hdmi-surround-extra3

    sleep 1

    exec ${pkgs.gamescope}/bin/gamescope --hdr-enabled -O HDMI-A-1 -w 3840 -h 2160 -e -- ${pkgs.steam}/bin/steam -steamdeck -steamos3
  '';

  desktop-mode = pkgs.writeShellScriptBin "desktop-mode" ''
    ${env-vars}

    /run/wrappers/bin/sudo ${pkgs.kbd}/bin/chvt 1

    ${pkgs.niri}/bin/niri msg output HDMI-A-1 off
    ${pkgs.niri}/bin/niri msg output DP-1 on
    ${pkgs.niri}/bin/niri msg output DP-2 on
    ${pkgs.niri}/bin/niri msg output DP-3 on
  '';

  steamos-session-select = pkgs.writeShellScriptBin "steamos-session-select" ''
    # Catch Steam's desktop invocation hooks
    if [ "$1" = "plasma" ] || [ "$1" = "desktop" ] || [ -z "$1" ]; then
      ${pkgs.curl}/bin/curl -s "http://127.0.0.1:9000/hooks/desktop-mode" &

      exec ${pkgs.steam}/bin/steam -shutdown >/dev/null 2>&1
    fi
  '';
in
{
  programs.gamescope.enable = true;

  # Make steamdeck mode to use this script when the switch to desktop option in the power menu is selected
  environment.systemPackages = [ steamos-session-select ];

  home-manager.users.justin = _: {
    programs.zsh.loginExtra = /*bash*/ ''
      if [ "$(tty)" = "/dev/tty3" ]; then
        exec ${gamescope-runner}/bin/gamescope-runner
      fi
    '';
  };

  systemd.services."getty@tty3" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = [
        ""
        "@${pkgs.util-linux}/sbin/agetty agetty --autologin justin --noclear %I $TERM"
      ];
      Restart = "no";
    };
  };

  services.webhook = {
    enable = true;
    user = "justin";
    group = "users";
    openFirewall = true;
    hooks = {
      ${lounge-mode.name}.execute-command = "${lounge-mode}/bin/${lounge-mode.name}";
      ${lounge-gamescope-mode.name}.execute-command = "${lounge-gamescope-mode}/bin/${lounge-gamescope-mode.name}";
      ${desktop-mode.name}.execute-command = "${desktop-mode}/bin/${desktop-mode.name}";
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

