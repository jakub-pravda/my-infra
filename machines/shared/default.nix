{config, ...}: {
  imports = [./datadog.nix];

  config = {
    # shared nix config
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "-d";
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
    };
  };
}
