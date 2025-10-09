let
  revachol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3vUHi5t6k5W/1P5VdFZtlvZmWbnk/S6qKMXVtBkar";
  #remember agenix uses ~/.ssh by default, not /etc/ssh
  night-city = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhc3kQySW5XFZbzta27rd2SSxI62gCnNeJ8DgMlBJO3";
  soul-matrix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIld/b48XwprSugh38a7ENoYchexDL6ANEbnKYWGljoq";
  
  servers = [ night-city soul-matrix ];
  users = [ revachol ];
  
  keys = users ++ servers;

in {
  "caddy.age".publicKeys = keys;
  "romm.age".publicKeys = keys;
  "romm-db.age".publicKeys = keys;
  "share.age".publicKeys = keys;
  "vpn.age".publicKeys = keys;
}

