import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/part/options.dart';
import 'package:precept_script/script/part/pPart.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';

part 'pString.g.dart';

///
/// - [property],[isStatic],[staticData], [caption],[tooltip],[help] - see [PPart]
@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PPart {
  PString({
    String property,
    String caption,
    IsStatic isStatic = IsStatic.inherited,
    String staticData,
    String tooltip,
    PHelp help,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
    PReadModeOptions readModeOptions = const PReadModeOptions(),
    PEditModeOptions editModeOptions = const PEditModeOptions(),
  }) : super(
          id: caption ?? id,
          caption: caption,
          property: property,
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          staticData: staticData,
          help: help,
          tooltip: tooltip,
          readModeOptions: readModeOptions,
          editModeOptions: editModeOptions,
        );

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PStringToJson(this);
}
