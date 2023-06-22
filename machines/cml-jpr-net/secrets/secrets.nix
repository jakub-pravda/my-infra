let
  jacob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILzk+JhkeYhc/PWG30HIDMPhSnhxIE6H3qnhyu7ekP9T";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2mLfva/VYFe71BRZBsMBuvDYIu7dGtL5EIA9x1bGv+";
in
{
  "datadog.age".publicKeys = [ system jacob ];
}