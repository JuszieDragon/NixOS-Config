{ pkgs, ... }: {
  users.users.justin.extraGroups = [ "seat" "video" ];

  environment.systemPackages = with pkgs; [
	  cage
	];
	
	services.seatd.enable = true;

  home-manager.users.justin = { ... }: {
    programs.zsh.loginExtra = ''
      if [ -z "$SSH_CONNECTION" ]; then
	      cage -d alacritty
	    fi
    '';
  };
}

