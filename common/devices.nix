{ ... }:
# All devices definition
{
  iot = {
    hubName = "myhome-kr";
    devices = [
      {
        id = "0x00124b00251f6180";
        name = "son-sns-01";
        type = "SNZB-02";
        location = "livingroom";
      }

      {
        id = "0x00124b0025132f8e";
        name = "son-sns-02";
        type = "SNZB-02";
        location = "bathroom";
      }

      {
        id = "0x00124b002513284a";
        name = "son-sns-03";
        type = "SNZB-02";
        location = "bedroom";
      }

      {
        id = "0x50325ffffe5720d4";
        name = "danfoss-thermo-01";
        type = "014G2461";
        location = "livingroom";
      }
    ];
  };
}
