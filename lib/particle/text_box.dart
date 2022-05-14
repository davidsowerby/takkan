import 'package:json_annotation/json_annotation.dart';

part 'text_box.g.dart';

@JsonSerializable(explicitToJson: true)
class TextBox {
  static const String defaultTraitName = 'TextBox-default';

  const TextBox();

  factory TextBox.fromJson(Map<String, dynamic> json) =>
      _$TextBoxFromJson(json);

  Map<String, dynamic> toJson() => _$TextBoxToJson(this);
}
