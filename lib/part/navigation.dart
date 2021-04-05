import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/particle/navigation.dart';
import 'package:precept_script/particle/particle.dart';

part 'navigation.g.dart';



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
