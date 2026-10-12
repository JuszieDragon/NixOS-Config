_: {
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    shellcheck = {
      enable = true;
    };
    statix.enable = true;
  };
}
