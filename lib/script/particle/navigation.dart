import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/script.dart';

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
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavPart extends PPart {
  PNavPart({
    bool readOnly = true,
    String styleName = 'default',
    @required String route,
    String caption,
    bool showCaption = false,
    IsStatic isStatic=IsStatic.yes,
    String property,
    String staticData='',
    final Map<String, dynamic> args = const {},
  }) : super(
            readOnly: readOnly,
            caption: caption,
            isStatic: isStatic,
            staticData: staticData,
            property: property,
            read: PNavParticle(
                route: route,
                caption: caption,
                showCaption: showCaption,
                args: args,
                styleName: styleName));

  factory PNavPart.fromJson(Map<String, dynamic> json) => _$PNavPartFromJson(json);

  Map<String, dynamic> toJson() => _$PNavPartToJson(this);
}
