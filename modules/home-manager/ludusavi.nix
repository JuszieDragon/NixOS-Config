{ pkgs, ... }: {
  home.packages = with pkgs; [
    ludusavi
  ];

  # services.ludusavi = {
  #   enable = true;
  #   settings = {
  #     backup = {
  #       path = "/mnt/nas/general/Saves";
  #     };
  #     customGames = {
  #       "Kitawa Shoujo: Re-Engineered" = {
  #         files = [ "" ];
  #       };
  #     };
  #   };
  # };
}
