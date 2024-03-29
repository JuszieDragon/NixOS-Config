{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    web-ext
  ];
}
