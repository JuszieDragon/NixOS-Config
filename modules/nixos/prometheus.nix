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
    ];
  };
}
