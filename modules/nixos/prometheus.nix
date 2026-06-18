{ catalog, ... }:
let
  cfg = catalog.services.prometheus;
  #TODO sort out how to handle service with multiple ports
  nodeExporterPort = 3021;

in
{
  services.prometheus = {
    inherit (cfg) enable port;

    exporters = {
      node = {
        port = nodeExporterPort;
        enabledCollectors = [ "systemd" ];
        enable = true;
      };
    };

    # ingest the published nodes
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "5s";
        scrape_timeout = "5s";

        static_configs = [
          {
            targets = [
              "0.0.0.0:9090"
            ];
          }
        ];
      }
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "0.0.0.0:${toString nodeExporterPort}"
              "0.0.0.0:${catalog.services.vector.portString}"
            ];
          }
        ];
      }
      {
        job_name = "caddy";
        static_configs = [
          {
            targets = [
              "0.0.0.0:2019"
            ];
          }
        ];
      }
    ];
  };
}
