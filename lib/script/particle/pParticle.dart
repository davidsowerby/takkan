abstract class PParticle {
  final String styleName;
  final bool showCaption;

  const PParticle({this.styleName = 'default', this.showCaption = true});
}

abstract class PReadParticle extends PParticle {
  const PReadParticle({String styleName = 'default', bool showCaption = true})
      : super(styleName: styleName, showCaption: showCaption);

  Map<String, dynamic> toJson();
}

abstract class PEditParticle extends PParticle {
  const PEditParticle({String styleName = 'default', bool showCaption = true})
      : super(styleName: styleName, showCaption: showCaption);

  Map<String, dynamic> toJson();
}
