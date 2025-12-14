let
  revachol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3vUHi5t6k5W/1P5VdFZtlvZmWbnk/S6qKMXVtBkar";
  #remember agenix uses ~/.ssh by default, not /etc/ssh
  night-city = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhc3kQySW5XFZbzta27rd2SSxI62gCnNeJ8DgMlBJO3";
  soul-matrix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIld/b48XwprSugh38a7ENoYchexDL6ANEbnKYWGljoq";
  last-defence-academy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsLqXr/dETjYP3ZlWFTn9yZ1euzbl6hFTj9CwXKYlXY";
  
  servers = [ night-city soul-matrix last-defence-academy ];
  users = [ revachol ];
  
  keys = users ++ servers;

in {
  "caddy.age".publicKeys = keys;
  "romm.age".publicKeys = keys;
  "romm-db.age".publicKeys = keys;
  "share.age".publicKeys = keys;
  "vpn.age".publicKeys = keys;
  "yarr.age".publicKeys = keys;
}

