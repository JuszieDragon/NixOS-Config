{ config, inputs, pkgs, ... }: {
  environment.systemPackages = [ pkgs.wireguard-tools ];

  age.secrets.nordlynx-private-key.file = inputs.self + /secrets/wireguard.age;

  networking = {
    nameservers = [ "1.0.0.1" "8.8.8.8" ];
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;

        # NordVPN default internal client IP
        address = [ "10.5.0.2/32" ];

        privateKeyFile = config.age.secrets.nordlynx-private-key.path;

        peers = [
          {
            #nix shell nixpkgs#curl nixpkgs#jq --command sh -c "curl -s 'https://api.nordvpn.com/v1/servers/recommendations?filters\[country_id\]=209&filters\[servers_technologies\]\[identifier\]=wireguard_udp&limit=1' | jq '.[] | {hostname, station, public_key: (.technologies[] | select(.identifier==\"wireguard_udp\") | .metadata[] | select(.name==\"public_key\") | .value)}'"
            # public_key from nord endpoint above
            publicKey = "SqAWBSVdnUJ859Bz2Nyt82rlSebMwPgvwQxIb1DzyF8=";

            allowedIPs = [ "0.0.0.0/0" ];

            # station IP followed by :51820
            endpoint = "37.120.213.91:51820";

            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  security.sudo.extraRules = [{
    users = [ "justin" ];
    commands = [{
      command = "/run/current-system/sw/bin/systemctl restart wg-quick-wg0.service";
      options = [ "NOPASSWD" ];
    }];
  }];
}
