abstract class Particle {
  final String styleName;
  final bool showCaption;

  const Particle({this.styleName = 'default', this.showCaption = true});

  Type get viewDataType;
}

abstract class ReadParticle extends Particle {
  const ReadParticle({String styleName = 'default', bool showCaption = true})
      : super(styleName: styleName, showCaption: showCaption);

  Map<String, dynamic> toJson();
}
