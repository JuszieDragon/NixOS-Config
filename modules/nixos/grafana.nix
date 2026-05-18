{ catalog, config, inputs, lib, ... }:

let
  cfg = catalog.services.grafana;
  prometheusDataSources = map (host: {
    name = "Prometheus ${host}";
    type = "prometheus";
    access = "proxy";
    url = "http://${catalog.hosts.${host}.ip}:${catalog.services.prometheus.portString}";
  }) catalog.services.prometheus.hosts;

in {
  age.secrets.grafana-key = lib.mkIf cfg.enable {
    file = inputs.self + /secrets/grafana-key.age;
    owner = "grafana";
  };

  services.grafana = {
    inherit (cfg) enable;

    settings = {
      analytics.reporting_enabled = false;
      server = {
        http_addr = "0.0.0.0";
        http_port = cfg.port;
      };

      security.secret_key = config.age.secrets.grafana-key.path;
    };

    provision = {
      enable = true;
      datasources.settings = {
        prune = true;
        datasources = prometheusDataSources;
      };
    };
  };
}
