{ inputs, lib, pkgs, ... }: {
  imports = [ inputs.steam-config-nix.homeModules.default ];

  programs.steam.config = {
    enable = true;
    closeSteam = true;
    
    apps = {
      Umamusume-Pretty-Derby = {
        id = 3224770;
        compatTool = "GE-Proton10-3";
      };
      # Native linux version doesn't detect mouse, might be niri related
      #TODO see if I can get this to set Proton Experimental instead
      Tabletop-Simulator = {
        id = 286160;
        compatTool = "GE-Proton10-3";
      };
    };
  };
}
