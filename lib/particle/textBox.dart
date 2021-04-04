import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/particle/particle.dart';

part 'textBox.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PTextBox extends PEditParticle{

  const PTextBox();

  factory PTextBox.fromJson(Map<String, dynamic> json) => _$PTextBoxFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PTextBoxToJson(this);
}