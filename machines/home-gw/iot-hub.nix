{
  id = "myhome-kr";
  devices = [
    # living room
    {
      id = "0x00124b00251f6180";
      name = "son-sns-01";
      type = "SNZB-02";
      location = "livingroom";
    }

    {
      id = "0x50325ffffe5720d4";
      name = "danfoss-thermo-01";
      type = "014G2461";
      location = "livingroom";
    }

    # bathroom
    {
      id = "0x00124b0025132f8e";
      name = "son-sns-02";
      type = "SNZB-02";
      location = "bathroom";
    }

    # bedroom
    {
      id = "0x00124b002513284a";
      name = "son-sns-03";
      type = "SNZB-02";
      location = "bedroom";
    }

    {
      id = "0xccccccfffe39fdca";
      name = "light-01";
      type = "IMM-LED";
      location = "bedroom";
    }

    {
      id = "0xccccccfffe3cd428";
      name = "light-02";
      type = "IMM-LED";
      location = "bedroom";
    }

    {
      id = "0xf082c0fffe99e1a0";
      name = "danfoss-thermo-02";
      type = "014G2461";
      location = "bedroom";
    }

    # outside
    {
      id = "0x00158d00091eb8df";
      name = "xia-tmp-01";
      type = "WSDCGQ11LM";
      location = "outside";
    }
  ];
}
