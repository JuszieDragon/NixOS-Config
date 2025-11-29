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
}

