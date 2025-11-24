class HSO_Functions {
  tag = "HSO";
  

  class QRF {
    file = "HSO_Functions\QRF";
    class callQRF {};
    class callQRFEH {};
    class initQRFSystem {};
    class initQRFSystemForPreplacedGrp {};
    class removeGrpFromQRFSystem {};
    class spawnQRF {};
    class terminateQRFSystem {};
  };

  class Compilers {
    file = "HSO_Functions\Compilers";
    class unitCompiler {};
    class groupCompiler {};
    class applyLoadout {};
    class registerHelper {};
  };

  class Ambient {
    file = "HSO_Functions\Ambient";
    class disableLights {};
    class disableLightsInteraction {};
    class cutGrass {};
    class cutGrassInteraction {};
  };
};

