import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/json/dataSourceConverter.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/part/options.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';

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
