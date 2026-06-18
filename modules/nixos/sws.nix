{ catalog, config, ... }: 
let 
  cfg = catalog.services.sws;
in {
  services.static-web-server = {
    inherit (cfg) enable;
    listen = "[::]:${cfg.portString}";            # Listens on port 8080 for both IPv4 and IPv6
    root = "/state/sws";
    configuration = {
      general = {
        directory-listing = true;
      };
    };
  };
}
