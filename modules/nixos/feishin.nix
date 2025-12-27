{ lib, pkgs, fetchPnpmDeps, ... }: {
  environment.systemPackages = with pkgs; [
    feishin
  ];

  nixpkgs.overlays = [( self: super: {
    feishin = super.feishin.overrideAttrs (previousAttrs: rec {
      version = "1.0.1-beta.1";
            
      src = super.fetchFromGitHub {
        tag = "v${version}";
        owner = "jeffvli";
        repo = "feishin";
        hash = "sha256-OLf84KJsbpE2C2UY76O6W23g2IsBc/vxhDG8TlNGf2I=";
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
