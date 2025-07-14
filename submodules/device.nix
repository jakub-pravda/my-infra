{ lib, ... }:
with lib; {
  options = {
    id = mkOption {
      type = types.str;
      example = "0x00124b00251f6180";
      description = "ID of the iot device.";
    };

    name = mkOption {
      type = types.str;
      example = "son-sns-01";
      description = "Friendly name of the iot device.";
    };

    type = mkOption {
      type = types.str; # TODO should be enum
      example = "SNZB-02";
      description = "Device type";
    };

    location = mkOption {
      type = types.str;
      example = "livingtoom";
      description = "Location tag of the iot device.";
    };
  };
}
