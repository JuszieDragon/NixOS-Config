{ catalog, ... }: {
  services.syncthing = {
    settings = {
      devices = {
        "eden" = { id = catalog.hosts.eden.syncthingId; };
        "revachol" = { id = catalog.hosts.revachol.syncthingId; };
      };
      folders = {
        "prism-launcher-instances" = {
          path = "/mnt/files/Syncthing/prism-launcher-instances";
          devices = [ "eden" "revachol" ];
        };
      };
    };
  };
}
