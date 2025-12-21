{ ... }: {
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor = {
        archive = "/state/gallery-dl/archive.sqlite3";
        base-directory = "/mnt/media/gallery-dl";
        skip = "abort:10";
        
        #TODO could use this to make cbzs
        #https://github.com/mikf/gallery-dl/issues/7471
        mangadex = {
          filename = {
            "subcategory == 'covers'" = "{volume:>03}_{lang}.{extension}";
            "" = "p{page:>03}.{extension}";
          };
          directory = {
            "subcategory == 'covers'" = ["{category}" "{manga}" "covers"];
            volume = ["{category}" "{manga}" "v{volume}" "c{chapter:>03}_{title}"];
            "" = ["{category}" "{manga}" "c{chapter:>03}"];
          };
          postprocessors = [
            {
              name = "metadata";
              event = "init";
              filename = "info.json";
            }
          ];
        };
      };
    };
  };
}

