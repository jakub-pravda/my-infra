_: {
  users.users.jacob = {
    isNormalUser = true;
    home = "/home/jacob";
    description = "Jacob";
    extraGroups = ["wheel" "networkmanager"];
  };

  nix.settings.allowed-users = ["jacob"];
}
