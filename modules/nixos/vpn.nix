{ pkgs, ... }: {
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    wgnord
    wireguard-tools
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/wgnord 0755 root root -"
    "d /etc/wireguard 0700 root root -"
  ];

  environment.etc."../var/lib/wgnord/template.conf".text = ''
    [Interface]
    PrivateKey = %PRIVATE_KEY%
    Address = %ADDRESS%
    DNS = %DNS%

    [Peer]
    PublicKey = %SERVER_PUBLIC_KEY%
    Endpoint = %SERVER_ENDPOINT%
    AllowedIPs = 0.0.0.0/0, ::/0
  '';
}
