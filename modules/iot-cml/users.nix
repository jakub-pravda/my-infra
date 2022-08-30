{ config, ... }:
{
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