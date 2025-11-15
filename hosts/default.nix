{ lib, pkgs, ... }: {
  users.users.justin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhc3kQySW5XFZbzta27rd2SSxI62gCnNeJ8DgMlBJO3" #night-city
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIld/b48XwprSugh38a7ENoYchexDL6ANEbnKYWGljoq" #soul-matrix
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsnE6XhdssoCsALupx4icoKIdwEWqbK7nAZo9PEST6y" #comp
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsUITUNFkh7hkAuaveCIUfLuFTIasNPLQv3N768eFHq" #revachol
    ];
  };

  time.timeZone = "Hobart/Australia";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };

  programs.zsh.enable = true;

  age.identityPaths = [ "/home/justin/.ssh/id_ed25519" ];
}
