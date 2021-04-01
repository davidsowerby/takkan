import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/particle/pParticle.dart';

part 'navigation.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavButton extends PReadParticle {
  final String route;
  final String caption;
  final Map<String, dynamic> args;

  PNavButton(
      {@required this.route, this.args = const {}, this.caption, String styleName, bool showCaption})
      : super(
          showCaption: showCaption,
          styleName: styleName,
        );

  factory PNavButton.fromJson(Map<String, dynamic> json) =>
      _$PNavButtonFromJson(json);

  Map<String, dynamic> toJson() => _$PNavButtonToJson(this);
}
