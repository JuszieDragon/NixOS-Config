let
  revachol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3vUHi5t6k5W/1P5VdFZtlvZmWbnk/S6qKMXVtBkar";
  #remember agenix uses ~/.ssh by default, not /etc/ssh
  night-city = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtlt9IOh+D0TKdQNhD2Gjlvkf4zdgguDuYzAj34Vg9g";
  soul-matrix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIld/b48XwprSugh38a7ENoYchexDL6ANEbnKYWGljoq";
  last-defence-academy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsLqXr/dETjYP3ZlWFTn9yZ1euzbl6hFTj9CwXKYlXY";
  eden-old = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJR2UrdB3XxtNZVi5Ggz4h+tkvhMb/91VuOkO/O/GCqD";
  eden = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDy3F+Jlmmceb4aw9mbaaarB+W3+jIBiVX7v8mG8+VBF";

  servers = [
    night-city
    soul-matrix
    last-defence-academy
  ];
  users = [
    revachol
    eden
    eden-old
  ];

  keys = users ++ servers;

in
{
  "caddy.age".publicKeys = keys;
  "forgejo-admin-password.age".publicKeys = keys;
  "grafana-key".publicKeys = keys;
  "kavita.age".publicKeys = keys;
  "restic-server-password.age".publicKeys = keys;
  "restic-repository-url.age".publicKeys = keys;
  "romm.age".publicKeys = keys;
  "romm-db.age".publicKeys = keys;
  "scrutiny-gotify.age".publicKeys = keys;
  "share.age".publicKeys = keys;
  "vpn.age".publicKeys = keys;
  "yarr.age".publicKeys = keys;
}
