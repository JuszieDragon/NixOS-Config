{ config, lib, pkgs, ... }: {
  options.firefox.enable = lib.mkEnableOption "Enable Firefox";

  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      profiles = {
        dev-edition-default = {
          id = 0;
          name = "dev-edition-default";
          isDefault = true;
          settings = {
            "browser.toolbars.bookmarks.visibility" = "always";
            "extensions.langpacks.signatures.required" = false;
            "media.hardwaremediakeys.enabled" = false;
            "signon.rememberSignons" = false;
            "signon.showAutoCompleteFooter" = false;
            "signon.autofillForms.autocompleteOff" = false;
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
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@no"];
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
