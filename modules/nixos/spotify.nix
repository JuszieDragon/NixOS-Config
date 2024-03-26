{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        spotify
    ];
    
    networking.firewall.allowedTCPPorts = [ 
        57621 # allow Spotify local file transfer
    ];
    networking.firewall.allowedUDPPorts = [ 
        5353 # allow Spotify to discover more connect devices
    ];
}