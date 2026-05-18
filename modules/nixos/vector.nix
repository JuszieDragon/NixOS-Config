{ catalog, lib, ... }:
with lib;

let
  cfg = catalog.services.vector;
  isCaddyHost = catalog.services.caddy.isEnabled;

in
{
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        journald.type = "journald";

        caddy = mkIf isCaddyHost {
          type = "file";
          include = [ "/var/log/caddy/*.log" ];
        };

        vector_metrics.type = "internal_metrics";
      };

      transforms = mkIf isCaddyHost {
        caddy_logs_timestamp = {
          type = "remap";
          inputs = [ "caddy" ];
          source = /* vrl */ ''
            .tmp_timestamp, err = parse_json!(.message).ts * 1000000

            if err != null {
              log("Unable to parse ts value: " + err, level: "error")
            } else {
              .timestamp = from_unix_timestamp!(to_int!(.tmp_timestamp), unit: "microseconds")
            }

            .SYSLOG_IDENTIFIER = "caddy"

            del(.tmp_timestamp)
          '';
        };
      };

      sinks = {
        loki = {
          type = "loki";
          encoding.codec = "json";
          inputs = [ "journald" ] ++ optionals isCaddyHost [ "caddy_logs_timestamp" ];
          endpoint = "http://0.0.0.0:${catalog.services.loki.portString}";

          labels.source = "journald";
        };

        prometheus_exporter = {
          type = "prometheus_exporter";
          inputs = [ "vector_metrics" ];
          address = "0.0.0.0:${cfg.portString}";
        };
      };
    };
  };

  systemd.services.vector.serviceConfig = mkIf isCaddyHost {
    SupplementaryGroups = [ "caddy" ];
  };
}
