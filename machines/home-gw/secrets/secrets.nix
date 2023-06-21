let
  jacob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ4mLnkO3Ylrtev1tsoj55wjY8hSUajnIGdC+tnIFOT";
in
{
  "datadog.age".publicKeys = [ jacob ];
}