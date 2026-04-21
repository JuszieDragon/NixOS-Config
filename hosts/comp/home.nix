{ lib, ... }: {
  imports = [ ../../modules/home-manager ];

  home = {
    homeDirectory = lib.mkForce "/data/data/com.termux.nix/files/home";
    stateVersion = lib.mkForce "24.05";
  };
}
