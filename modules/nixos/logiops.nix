{ pkgs, ... }:

{
  # Install logiops package
  environment.systemPackages = with pkgs; [
    logiops_0_2_3
  ];

  # Create systemd service
  systemd.services.logiops = with pkgs; {
    description = "An unofficial userspace driver for HID++ Logitech devices";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${logiops}/bin/logid";
    };
  };
}

