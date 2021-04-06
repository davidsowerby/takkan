import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/particle/particle.dart';

part 'navigation.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavParticle extends PReadParticle {
  final String route;
  final String caption;
  final Map<String, dynamic> args;

  PNavParticle(
      {@required this.route,
      this.args = const {},
      this.caption,
      String styleName,
      bool showCaption})
      : super(
          showCaption: showCaption,
          styleName: styleName,
        );

  factory PNavParticle.fromJson(Map<String, dynamic> json) => _$PNavParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PNavParticleToJson(this);

  @override
  Type get viewDataType => String;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavButtonSetParticle extends PReadParticle {
  final Map<String, String> buttons;
  final double width;
  final double height;

  PNavButtonSetParticle({
    this.buttons = const {},
    this.width = 150,
    this.height,
  });

  factory PNavButtonSetParticle.fromJson(Map<String, dynamic> json) =>
      _$PNavButtonSetParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PNavButtonSetParticleToJson(this);

  @override
  Type get viewDataType => String;
}
