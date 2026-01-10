{ lib, pkgs, ... }: {
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtlt9IOh+D0TKdQNhD2Gjlvkf4zdgguDuYzAj34Vg9g" #night-city
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIld/b48XwprSugh38a7ENoYchexDL6ANEbnKYWGljoq" #soul-matrix
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsnE6XhdssoCsALupx4icoKIdwEWqbK7nAZo9PEST6y" #comp
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsLqXr/dETjYP3ZlWFTn9yZ1euzbl6hFTj9CwXKYlXY" #last-defence-academy
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsUITUNFkh7hkAuaveCIUfLuFTIasNPLQv3N768eFHq" #revachol
    ];
  };

  time.timeZone = "Australia/Hobart";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "justin" ];
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };

  environment.enableAllTerminfo = true;

  programs.zsh.enable = true;

  age.identityPaths = [ "/home/justin/.ssh/id_ed25519" ];
}
