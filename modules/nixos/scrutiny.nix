{ catalog, config, ... }: 


let
  cfg = catalog.services.scrutiny;
  hostName = config.networking.hostName;

in {
  services.scrutiny = {
    enable = cfg.isEnabled hostName;
    settings.web.listen.port = cfg.port;
  };
}

