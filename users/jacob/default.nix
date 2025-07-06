_: {
  users.users.jacob = {
    isNormalUser = true;
    home = "/home/jacob";
    description = "Main repo user";
    extraGroups = ["docker" "wheel" "networkmanager"];
    openssh.authorizedKeys.keyFiles = [./keyfile];
  };
}
