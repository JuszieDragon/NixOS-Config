{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;

    profiles.justin = {
      settings = {
        "media.hardwaremediakeys.enabled" = false;
        "xpinstall.signatures.required" = false;
      };

      search.engines = {
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
      search.force = true;

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        honey
        ublock-origin
        return-youtube-dislikes
        windscribe
        translate-web-pages
        image-search-options
      ];
    };
  };
}
