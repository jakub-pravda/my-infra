let
  livingRoomLocation = "livingroom";
  bathroomLocation = "bathroom";
  bedroomLocation = "bedroom";
  hallLocation = "hall";
  outsideLocation = "outside";
in {
  id = "myhome-kr";
  devices = [
    # living room
    {
      id = "0x00158d00094a0833";
      name = "xia-tmp-02";
      type = "WSDCGQ11LM";
      location = livingRoomLocation;
    }

    {
      id = "0x50325ffffe5720d4";
      name = "danfoss-thermo-01";
      type = "014G2461";
      location = livingRoomLocation;
    }

    # bathroom
    {
      id = "0x00124b0025132f8e";
      name = "son-sns-02";
      type = "SNZB-02";
      location = bathroomLocation;
    }

    # bedroom
    {
      id = "0x00124b002513284a";
      name = "son-sns-03";
      type = "SNZB-02";
      location = bedroomLocation;
    }

    {
      id = "0xccccccfffe39fdca";
      name = "light-01";
      type = "IMM-LED";
      location = bedroomLocation;
    }

    {
      id = "0xccccccfffe3cd428";
      name = "light-02";
      type = "IMM-LED";
      location = bedroomLocation;
    }

    {
      id = "0xf082c0fffe99e1a0";
      name = "danfoss-thermo-02";
      type = "014G2461";
      location = bedroomLocation;
    }

    # hall
    {
      id = "0x00124b00251f6180";
      name = "son-sns-01";
      type = "SNZB-02";
      location = hallLocation;
    }

    # outside
    {
      id = "0x00158d00091eb8df";
      name = "xia-tmp-01";
      type = "WSDCGQ11LM";
      location = outsideLocation;
    }
  ];
}
