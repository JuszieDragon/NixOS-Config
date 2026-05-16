{ catalog, config, ... }:
let
  cfg = catalog.services.prometheus;
  nodeExporterPort = 3021;

in {
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
    scrapeConfigs = [{
      job_name = "nodes";
      static_configs = [{
        targets = [
          "0.0.0.0:${toString nodeExporterPort}"
        ];
      }];
    }];
  };
}
