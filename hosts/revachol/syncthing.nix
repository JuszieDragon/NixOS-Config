{ catalog, ... }: {
  services.syncthing = {
    settings = {
      devices = {
        "eden" = { id = catalog.hosts.eden.syncthingId; };
        "soul-matrix" = { id = catalog.hosts.soul-matrix.syncthingId; };
      };
      folders = {
        "prism-launcher-instances" = {
          path = "/home/justin/.local/share/PrismLauncher/instances";
          devices = [ "eden" "soul-matrix" ];
        };
      };
    };
  };
}
