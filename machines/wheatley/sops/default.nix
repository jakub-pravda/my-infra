{
  sops-nix,
  config,
  ...
}:
{
  imports = [
    sops-nix.nixosModules.sops
  ];
  config = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.users.users.jacob.home}/.config/sops/age/keys.txt";
      secrets."api_gw_keys/open_ai" = { };
      secrets."api_gw_keys/anthrophic" = { };
    };
  };
}
