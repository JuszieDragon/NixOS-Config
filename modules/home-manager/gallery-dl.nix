{ ... }: {
  programs.gallery-dl = {
    enable = true;
    settings = {
      #TODO make mangafox download to volume folders
      extractor.base-directory = "/mnt/media/gallery-dl";
    };
  };
}

