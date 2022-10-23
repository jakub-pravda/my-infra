{ ... }:
# All devices definition
{ iot = {
    hubName = "myhome-kr";
    devices = [
      { id        = "0x00124b00251f6180";
        name      = "son-sns-01";
        type      = "SNZB-02";
        location  = "livr";
      }
    ];
  };
}