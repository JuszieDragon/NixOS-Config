{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  age.secrets.radicale-password.file = inputs.self + /secrets/radicale-password.age;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = (builtins.fromTOML (builtins.readFile ./settings.toml)) // {
      calendar = {
        account."radicale" = {
          provider = "custom";
          type = "caldav";
          server_url = "https://radicale.dragon.luxe/justin/ddcba505-a90f-8ce7-d29e-0c83c20a3a03";
          username = "justin";

          credential_source = "file";
          password_file = config.age.secrets.radicale-password.path;
        };
      };
    };
  };
}
