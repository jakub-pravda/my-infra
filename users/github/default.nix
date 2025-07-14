_: {
  users.users.github = {
    isNormalUser = true;
    home = "/home/github";
    description = "User with access to github";
    extraGroups = [ "networkmanager" ];
  };
}
