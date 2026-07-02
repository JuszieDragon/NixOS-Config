{ catalog, pkgs, ... }: {
  users.users.justin.extraGroups = [
    "seat"
    "video"
  ];

  environment.systemPackages = with pkgs; [
    cage
    (writeShellScriptBin "3dcam" ''
      ${cage}/bin/cage -d ${mpv}/bin/mpv -- --cache-secs=0 --demuxer-readahead-secs=0 http://${catalog.hosts.centauri-carbon.ip}:3031/video 
    '')
  ];

  services.seatd.enable = true;

  home-manager.users.justin = _: {
    programs.zsh.loginExtra = /*bash*/ ''
      if [ -z "$SSH_CONNECTION" ]; then
      	cage -d alacritty
      fi
    '';
  };
}
