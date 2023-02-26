{ config, pkgs, ... }: {
  imports =
    [ ../shared ../../modules/services ./vpsadminos.nix ./wg-server.nix ];

  networking.hostName = "cml-jpr-net";

  environment.systemPackages = with pkgs; [
    atop
    git
    kcat
    vim
    openssl
    tcpdump
    wireguard-tools
  ];

  environment.etc."nixos/configuration.nix" = {
    source = "/home/jacfal/my-infra/machines/cml-jpr-net/configuration.nix";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # http
      443 # https
      1883 # mosquitto
    ];
    allowedUDPPorts = [
      51820 # wireguard VPN
    ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
    stateVersion = "22.05";
  };

  # allow machine specific services
  services = {
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };

    jacfal-wiki.enable = true;

    iot-cml = {
      enable = true;
      hubConfigs =
        let utils = pkgs.callPackage ../../machines/shared/utils.nix { };
        in utils.getAllHubConfigs ../../machines;
      wireguardInterfaceIp = "10.100.0.1";
    };

    my-nginx.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };
  
  users.users.jacfal = {
    isNormalUser  = true;
    home  = "/home/jacfal";
    description  = "Jacob True";
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys  = [ 
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCia/yKt0uyafrynjTeulM868kMUD44QvvVQoePJ38GvW9VkXKG16KpwSAS1sCHQdVvkq3kKL4KRrgtqFtY1zEgx0UpEnhNztUqLCAbGNFnadD+UbYKhAeHxWvx8/NT3T5vUnAdCcgP4vpxD7PUqeTIFZwvJ/wzSSQMRkdzbDdoSIn8hltAI7caQFMBa8Hsm2yXb0p063MMz+6SWY8uaDuMIjcaKpEHcQl49pEMhyr2mh1bGJCg3HAoV+EB1IDrvQx9p+spPdzwS+JyW8fSVeEYlzMG4gSSQv3EHr5vKTu0NfsokAUIbnAkKca9sIRqF3Gu9B4vIfnp487Gn19PIvKRE7h6kBOG2wZZk/G2mNe6Q1FK3dkDrEUMXtBz4S3GKB3C8yfzjqymG1x+VZoIUH4e3v2f9wNrOE0c1loMZLIqvwGSaUYMT6wx1zP82bDR6U2/FDchHjGIALn5IOQEEYZjPGGaZ7YIwB/Fbr4zysLhaxRGaN/iP9JOftgOr5w6Qt0= jacob@BSS-3FLH9K3" 
      ];
  };
}
