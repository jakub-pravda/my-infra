let
  system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxpj5PPnDiujOmld4K9hi1SA+PJVUaW1gN0SYw/9Oa/";
in { "datadog.age".publicKeys = [ system ]; }
