{ lib, pkgs, fetchPnpmDeps, ... }: {
  environment.systemPackages = with pkgs; [
    feishin
    playerctl
  ];

  nixpkgs.overlays = [( self: super: {
    feishin = super.feishin.overrideAttrs (previousAttrs: rec {
      version = "1.0.2";
            
      src = super.fetchFromGitHub {
        tag = "v${version}";
        owner = "jeffvli";
        repo = "feishin";
        hash = "sha256-otobV3bpANbhrAiscDxV1IGJ36i/37aPei6wdo5SDSw=";
      };

      pnpmDeps = super.fetchPnpmDeps {
        inherit version src;
        pname = previousAttrs.pname;
        fetcherVersion = 2;
        hash = "sha256-iZs2YtB0U8RpZXrIYHBc/cgFISDF/4tz+D13/+HlszU";
      };
    });
  })];
}
