_:
let publicKey = "bTCvk4lOEOdiK1sm+rxe+3Nz1fkWp6A/uQEmnEGHGwk=";
in {
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = "/home/jacfal/.wireguard-keys/private";
      postSetup = [ "wg set wg0 peer ${publicKey} persistent-keepalive 25" ];
      peers = [
        # CML - vpsfree
        {
          inherit publicKey;
          allowedIPs = [ "10.100.0.0/24" ];
          endpoint = "37.205.13.151:51820";
        }
      ];
    };
  };
}
