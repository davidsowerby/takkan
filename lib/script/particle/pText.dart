import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/particle/pParticle.dart';

part 'pText.g.dart';

///
/// - configures a Flutter Text widget
@JsonSerializable(nullable: true, explicitToJson: true)
class PText extends PReadParticle {
  const PText({String styleName = 'default', bool showCaption = true}) :  super(styleName: styleName, showCaption: showCaption);

  factory PText.fromJson(Map<String, dynamic> json) => _$PTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PTextToJson(this);
}
