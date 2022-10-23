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

      { id        = "0x00124b0025132f8e";
        name      = "son-sns-02";
        type      = "SNZB-02";
        location  = "bthrm";
      }
    ];
  };
}