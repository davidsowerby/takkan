import 'package:json_annotation/json_annotation.dart';

part 'textBox.g.dart';

@JsonSerializable( explicitToJson: true)
class PTextBox {
  static const String defaultTraitName = 'PTextBox-default';

  const PTextBox();

  factory PTextBox.fromJson(Map<String, dynamic> json) => _$PTextBoxFromJson(json);

  Map<String, dynamic> toJson() => _$PTextBoxToJson(this);
}
