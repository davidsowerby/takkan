import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/debug.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/element.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/json/dataSourceConverter.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/part/options.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/writingStyle.dart';
import 'package:precept_script/validation/message.dart';

part 'pPart.g.dart';

/// Contained within a [PScript] a [PPart] describes a [Part]
/// [T] is the data type as held by the database.  Depending on how it is displayed, this may need conversion
/// [isStatic] - if true, the value is taken from [staticData], if false, the value is dynamic data loaded via [property]
/// [staticData] - the value to use if [isStatic] is true. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [SectionState] immediately above the [Part] Widget associated with this configuration.
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [SectionState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
///
/// [RO] type of read options
/// [WO] type of write options
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart extends PDisplayElement {
  final bool readOnly;
  final String property;
  final String staticData;
  final PHelp help;
  final String tooltip;
  final PReadModeOptions readModeOptions;
  final PEditModeOptions editModeOptions;

  PPart(
      {String caption,
      this.readOnly = false,
      this.property,
      IsStatic isStatic = IsStatic.inherited,
      this.staticData,
      this.help,
      PBackend backend,
      PDataSource dataSource,
      PPanelStyle panelStyle,
      WritingStyle writingStyle,
      ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
      String id,
      this.readModeOptions,
      this.editModeOptions,
      this.tooltip})
      : super(
          id: id,
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          caption: caption,
        );

  factory PPart.fromJson(Map<String, dynamic> json) => _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);

  DebugNode get debugNode {
    final List <DebugNode> children =  List();
    if (backendIsDeclared){
      children.add(backend.debugNode);
    }
    if (dataSourceIsDeclared){
      children.add(dataSource.debugNode);
    }
    return DebugNode(this,children);
  }
  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (isStatic != IsStatic.yes) {
      if (property == null || property.isEmpty) {
        messages.add(ValidationMessage(
            item: this,
            msg: 'unless a Part is static, it must provide a non-null, non-empty property'));
      }
    }
    if (readModeOptions.showCaption) {
      if (caption == null || caption.isEmpty) {
        messages.add(ValidationMessage(
            item: this, msg: 'readOnlyOptions.showCaption is true, so a caption must be provided'));
      }
    }
  }


}
