{ lib, inputs, pkgs, ... }: {
  options.firefox.enable = lib.mkEnableOption "Enable Firefox";
  
  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;

      profiles = {
        dev-edition-default = {
          id = 0;
          name = "dev-edition-default";
          isDefault = true;
          settings = {
            "media.hardwaremediakeys.enabled" = false;
            "xpinstall.signatures.required" = false;
          };

          search = {
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "ProtonDB" = {
                urls = [
                  {
                    template = "https://www.protondb.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                definedAliases = ["@pdb"];
              };
            };
          };
        };
      };
    };
  };
}
