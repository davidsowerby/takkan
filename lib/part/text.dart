import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/part/part.dart';

part 'text.g.dart';

@JsonSerializable(explicitToJson: true)
class Text extends Part {
  static const String defaultReadTrait = 'text-read-default';
  static const String heading1 = 'text-heading-1';
  static const String heading2 = 'text-heading-2';
  static const String heading3 = 'text-heading-3';
  static const String title = 'text-title';
  static const String subtitle = 'text-subtitle';
  static const String strapText = 'text-strapText';
  static const String body = 'text-body';
  static const String errorText = 'text-error';

  Text(
      {super.caption,
      super.readOnly = false,
      super.height = 60,
      super.property,
      super.readTraitName = 'text-read-default',
      super.editTraitName = 'TextBox-default',
      super.staticData,
      super.help,
      super.controlEdit = ControlEdit.inherited,
      super.id,
      super.tooltip});

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextToJson(this);
}
