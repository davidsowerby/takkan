abstract class Particle {
  final String styleName;
  final bool showCaption;

  const Particle({this.styleName = 'default', this.showCaption = true});

  Type get viewDataType;
}

abstract class ReadParticle extends Particle {
  const ReadParticle({
    super.styleName = 'default',
    super.showCaption = true,
  });

  Map<String, dynamic> toJson();
}
