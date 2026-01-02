{ lib, pkgs, fetchPnpmDeps, ... }: {
  environment.systemPackages = with pkgs; [
    feishin
    playerctl
  ];

  nixpkgs.overlays = [( self: super: {
    feishin = super.feishin.overrideAttrs (previousAttrs: rec {
      version = "1.1.0";
            
      src = super.fetchFromGitHub {
        tag = "v${version}";
        owner = "jeffvli";
        repo = "feishin";
        hash = "sha256-8/2gHa030EtllPayMu1J62wn8CKy8/MNIdqet/8+eYQ=";
      };

      pnpmDeps = super.fetchPnpmDeps {
        inherit version src;
        pname = previousAttrs.pname;
        fetcherVersion = 2;
        hash = "sha256-cIHwCZg7sf4phEZMCX4Y/4CGnGEPvL1spNt4GgEVLPw=";
      };
    });
  })];
}
