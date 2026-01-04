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
      Tabletop-Simulator = {
        id = 286160;
        compatTool = "proton_experimental";
      };
    };
  };
}
