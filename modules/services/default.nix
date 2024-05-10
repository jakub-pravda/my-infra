{...}: {
  imports = [
    ./auto-update.nix
    ./flake-update.nix
    ./home-assistant.nix
    ./iot-cml
    ./iot-gw.nix
    ./jacfal-wiki.nix
    ./nginx.nix
    ./tss.nix
    ./tsc.nix
  ];
}
