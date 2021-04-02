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
    IsStatic isStatic = IsStatic.yes,
    String property,
    String staticData = '',
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

/// A simple way to specify a list of buttons which only route to another page
/// [buttons] should be specified as a map, for example {'button text':'route'}
@JsonSerializable(nullable: true, explicitToJson: true)
class PNavButtonSet extends PPart {
  PNavButtonSet({
    Map<String, String> buttons = const {},
    double width = 150,
    double height,
  }) : super(
            readOnly: true,
            isStatic: IsStatic.yes,
            read: PNavButtonSetParticle(
              buttons: buttons,
              width: width,
              height: height,
            ));

  factory PNavButtonSet.fromJson(Map<String, dynamic> json) => _$PNavButtonSetFromJson(json);

  Map<String, dynamic> toJson() => _$PNavButtonSetToJson(this);
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
}
