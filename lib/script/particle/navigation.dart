import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/particle/pParticle.dart';

part 'navigation.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavigationButton extends PReadParticle {
  final String route;
  final String caption;
  final Map<String, dynamic> args;

  PNavigationButton(
      {@required this.route, this.args = const {}, this.caption, String styleName, bool showCaption})
      : super(
          showCaption: showCaption,
          styleName: styleName,
        );

  factory PNavigationButton.fromJson(Map<String, dynamic> json) =>
      _$PNavigationButtonFromJson(json);

  Map<String, dynamic> toJson() => _$PNavigationButtonToJson(this);
}
