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
    };
  };
}
