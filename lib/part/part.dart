import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'part.g.dart';

/// Contained within a [PScript] a [PPart] describes a [Part]
/// [T] is the data type as held by the database.  Depending on how it is displayed, this may need conversion
/// [isStatic] - if true, the value is taken from [staticData], if false, the value is dynamic data loaded via [property]
/// [staticData] - the value to use if [isStatic] is true. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [EditState] immediately above the [Part] Widget associated with this configuration.
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [EditState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [height] - is set here because both read and edit particles need to be the same height to avoid display 'jumping' when switching between read and edit modes.
/// [dataProvider] and [query] are theoretically available by virtue of inheriting [PSubContent], but do not make sense for a [PPart], as it represents a single field
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart extends PSubContent {
  final bool readOnly;
  final String property;
  final String staticData;
  final PHelp help;
  final String tooltip;
  final double height;
  final String readTraitName;
  final String editTraitName;

  PPart(
      {String caption,
      this.readOnly = false,
      this.height = 60,
      this.property,
      this.readTraitName,
      this.editTraitName,
      IsStatic isStatic = IsStatic.inherited,
      this.staticData,
      this.help,
      ControlEdit controlEdit = ControlEdit.inherited,
      String id,
      this.tooltip})
      : super(
          id: id,
          isStatic: isStatic,
          controlEdit: controlEdit,
          caption: caption,
        );

  factory PPart.fromJson(Map<String, dynamic> json) => _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);

  DebugNode get debugNode {
    final List<DebugNode> children = List();
    if (dataProviderIsDeclared) {
      children.add(dataProvider.debugNode);
    }
    if (queryIsDeclared) {
      children.add(query.debugNode);
    }
    return DebugNode(this, children);
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (isStatic != IsStatic.yes || readOnly) {
      if (property == null || property.isEmpty) {
        messages.add(ValidationMessage(
            item: this,
            msg:
                'unless a Part is static or readOnly, it must provide a non-null, non-empty property'));
      }
    }
    // if (readModeOptions.showCaption) {
    //   if (caption == null || caption.isEmpty) {
    //     messages.add(ValidationMessage(
    //         item: this, msg: 'readOnlyOptions.showCaption is true, so a caption must be provided'));
    //   }
    // }
  }
}
