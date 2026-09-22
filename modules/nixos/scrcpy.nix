{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    android-tools
    scrcpy
  ];

  users.users.justin.extraGroups = [ "adbusers" ];
}
