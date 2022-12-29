{ pkgs, ... }:
let
  externalInterface = "venet0@if816";
  wgInterfaceName = "wg0";
  inetPrefix      = "10.100.0.1/24";
in {
  networking.nat = {
    inherit externalInterface;
    enable = true;
    internalInterfaces = [ wgInterfaceName ];
  };

  networking.wireguard.interfaces = {
    "${wgInterfaceName}" = {
      # tunnel interface ip range
      ips         = [ inetPrefix ];
      listenPort  = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${inetPrefix} -o ${externalInterface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${inetPrefix} -o ${externalInterface} -j MASQUERADE
      '';
      
      privateKeyFile  = "/home/jacfal/.wireguard-keys/private";
      peers = [
      # my home kralupska NODE
        {
          publicKey = "i3qL42QskKg2sRBnAuwfmu7aofACIbo1STurn8kOAWg=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };
}