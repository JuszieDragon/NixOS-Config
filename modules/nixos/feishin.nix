{ lib, pkgs, fetchPnpmDeps, ... }: {
  environment.systemPackages = with pkgs; [
    feishin
    playerctl
  ];

  nixpkgs.overlays = [( self: super: {
    feishin = super.feishin.overrideAttrs (previousAttrs: rec {
      version = "1.2.0";
            
      src = super.fetchFromGitHub {
        tag = "v${version}";
        owner = "jeffvli";
        repo = "feishin";
        hash = "sha256-ycKW3tY2chWdkYebPYYoEuANF/c+yYUAS0v1w1iz66A=";
      };

      pnpmDeps = super.fetchPnpmDeps {
        inherit version src;
        pname = previousAttrs.pname;
        fetcherVersion = 2;
        hash = "sha256-rKzmc2BPtgTUwXG2y00mURYuTrWawR9l7D+IJwLYtz8=";
      };
    });
  })];
}
