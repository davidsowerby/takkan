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
      {String? caption,
      bool readOnly = false,
      double height = 60,
      String? property,
      String readTraitName = 'text-read-default',
      String editTraitName = 'TextBox-default',
      String? staticData,
      Help? help,
      ControlEdit controlEdit = ControlEdit.inherited,
      String? id,
      String? tooltip})
      : super(
          readOnly: readOnly,
          readTraitName: readTraitName,
          height: height,
          property: property,
          editTraitName: editTraitName,
          controlEdit: controlEdit,
          staticData: staticData,
          caption: caption,
          help: help,
          id: id,
          tooltip: tooltip,
        );

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextToJson(this);
}
