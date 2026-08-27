{ catalog, ... }: {
  services.syncthing = {
    settings = {
      devices = {
        "revachol" = { id = catalog.hosts.revachol.syncthingId; };
        "soul-matrix" = { id = catalog.hosts.soul-matrix.syncthingId; };
      };
      folders = {
        "prism-launcher-instances" = {
          path = "/home/justin/.local/share/PrismLauncher/instances";
          devices = [ "eden" "revachol" ];
        };
      };
    };
  };
}
