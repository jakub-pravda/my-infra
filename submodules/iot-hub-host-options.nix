{lib, ...}:
with lib; {
  options = {
    id = mkOption {
      type = types.str;
      example = "myhome";
      description = "Unique id name of the iot hub";
    };

    devices = mkOption {
      type = types.listOf (types.submodule (import ./device.nix));
      description = "Hub IoT devices";
    };
  };
}
