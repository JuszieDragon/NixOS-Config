{ ... }: {
  programs.niri.settings.layout = {
    gaps = 5;
    preset-column-widths = [
      { proportion = 1. / 3.; }
      { proportion = 1. / 2.; }
      { proportion = 2. / 3.; }
    ];
    default-column-width = { proportion = 0.5; };

    focus-ring = {
      width = 1.5;
      #active-color
      #inactive-color
    };
  };
}
