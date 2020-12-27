import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pParticle.dart';

part 'pText.g.dart';

///
/// - [property],[isStatic],[staticData], [caption],[tooltip],[help] - see [PPart]
@JsonSerializable(nullable: true, explicitToJson: true)
class PText extends PReadParticle {
  const PText();

  factory PText.fromJson(Map<String, dynamic> json) => _$PTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PTextToJson(this);
}
