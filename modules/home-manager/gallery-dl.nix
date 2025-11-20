{ ... }: {
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor.base-directory = "/mnt/media/gallery-dl";
    };
  };
}

