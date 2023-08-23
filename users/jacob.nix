{
  config,
  pkgs,
  jacob-keys,
  ...
}: {
  users.users.jacob = {
    isNormalUser = true;
    home = "/home/jacob";
    description = "Jacob";
    extraGroups = ["docker" "wheel" "networkmanager"];
    openssh.authorizedKeys.keyFiles = [jacob-keys];
  };

  nix.settings.allowed-users = ["jacob"];
}
