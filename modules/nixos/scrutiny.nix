{ catalog, config, ... }: 


let
  cfg = catalog.services.scrutiny;

in {
  services.scrutiny = {
    enable = cfg.isEnabled;
    settings.web.listen = {
      port = cfg.port;
      host = cfg.host.ip; #TODO chenge this to work with multihost
    };
  };

  nixpkgs.overlays = [( final: prev: 
    let
      scrutinyVersion = "0.8.6";
      scrutinySrc = prev.fetchFromGitHub {
        owner = "AnalogJ";
        repo = "scrutiny";
        tag = "v${scrutinyVersion}";
        hash = "sha256-0NgAdgtlsAetXfFqJdYpvzEXL4Ibh4yzAjOaOFoMvrs=";
      };
      scrutinyVendorHash = "sha256-4qjKGjCvB0ggf6Cda7LfMeqbbBbhGcxB2ZfymUhajq8=";
    in
    {
      scrutiny = prev.scrutiny.overrideAttrs (oldAttrs: rec {
        version = scrutinyVersion;
        src = scrutinySrc;
    
        frontend = prev.buildNpmPackage {
          inherit version;
          pname = "scrutiny-webapp";
          src = "${scrutinySrc}/webapp/frontend";
    
          npmDepsHash = "sha256-EgIM3iu/dGQhzanWjjBFmLHU3EOy2riScXCDSwAvAZc=";
    
          buildPhase = ''
            runHook preBuild
            mkdir dist
            npm run build:prod --offline -- --output-path=dist
            runHook postBuild
          '';
    
          installPhase = ''
            runHook preInstall
            mkdir $out
            cp -r dist/* $out
            runHook postInstall
          '';
    
          passthru.updateScript = prev.nix-update-script { };
        };
    
        vendorHash = scrutinyVendorHash;
      });
    
      scrutiny-collector = prev.scrutiny-collector.overrideAttrs (oldAttrs: {
        version = scrutinyVersion;
        src = scrutinySrc;
        vendorHash = scrutinyVendorHash;
      });
    }
  )];
}

