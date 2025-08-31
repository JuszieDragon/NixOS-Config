let
  revachol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn3vUHi5t6k5W/1P5VdFZtlvZmWbnk/S6qKMXVtBkar";

  #remember agenix uses ~/.ssh by default, not /etc/ssh
  night-city = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhc3kQySW5XFZbzta27rd2SSxI62gCnNeJ8DgMlBJO3";
  
  servers = [ night-city ];
  users = [ revachol ];
  
  keys = users ++ servers;

in {
  "caddy.age".publicKeys = keys;
  "romm.age".publicKeys = keys;
  "romm-db.age".publicKeys = keys;
  "transmission.age".publicKeys = keys;
}

