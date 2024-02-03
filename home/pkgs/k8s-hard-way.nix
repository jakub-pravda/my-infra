# Packages required by the kubernetes the hard way course
# I'm keeping the package definition here instead of the separate project
# as I'm not planning to define K8S infrastructure as IaC and it'll live 
# only as a playground on GCP
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      google-cloud-sdk
    ];
  };
}
