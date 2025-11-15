{ config, inputs, lib, pkgs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    bat
    diffutils
    findutils
    git
    gnugrep
    gnused
    hostname
    man
    nano
    openssh
    tmux
    utillinux
    zsh
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Australia/Hobart";

  user = {
    userName = lib.mkForce "justin";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager = {
    config = ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
