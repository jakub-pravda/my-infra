let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzlaCdKDGbuPdfTtJuvswLCYKA2iQGa4xzS8wCb1yfM";
in
{
  "datadog.age".publicKeys = [ system ];
}