import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/part.dart';

part 'text.g.dart';

@JsonSerializable( explicitToJson: true)
class PText extends PPart {
  static const String defaultReadTrait = 'text-read-default';
  static const String heading1 = 'text-heading-1';
  static const String heading2 = 'text-heading-2';
  static const String heading3 = 'text-heading-3';
  static const String title = 'text-title';
  static const String subtitle = 'text-subtitle';
  static const String strapText = 'text-strapText';
  static const String body = 'text-body';
  static const String errorText = 'text-error';

  PText(
      {String? caption,
      bool readOnly = false,
      double height = 60,
      String property = notSet,
      String readTraitName = 'text-read-default',
      String editTraitName = 'PTextBox-default',
      IsStatic isStatic = IsStatic.inherited,
      String staticData = notSet,
      PHelp? help,
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
          isStatic: isStatic,
          help: help,
          id: id,
          tooltip: tooltip,
        );

  factory PText.fromJson(Map<String, dynamic> json) => _$PTextFromJson(json);

  Map<String, dynamic> toJson() => _$PTextToJson(this);
}
