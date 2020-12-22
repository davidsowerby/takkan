abstract class PParticle {

  const PParticle();
}

abstract class PReadParticle extends PParticle {

  const PReadParticle();
  Map<String, dynamic> toJson();
}

abstract class PEditParticle extends PParticle {

  const PEditParticle();
  Map<String, dynamic> toJson();
}
