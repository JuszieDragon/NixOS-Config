{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

with lib;

let cfg = config.modules.openspeedtest;

in {
  options.modules.openspeedtest.enable = mkEnableOption "Run OpenSpeedTest";

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      openspeedtest = {
        image = "openspeedtest/latest";
        ports = ["3000:3000"];
      };
    };
  };
}
