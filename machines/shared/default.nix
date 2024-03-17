{config, ...}: {
  imports = [./datadog.nix];

  # default config
  config = { 
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
    }; 
  };
}
