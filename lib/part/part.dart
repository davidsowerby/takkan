import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'part.g.dart';

/// Contained within a [PScript] a [PPart] describes a [Part], which presents the data for a single field.
///
/// A Part usually presents two different widgets, one for readOnly mode and one for edit mode.
///
/// More sophisticated Parts may present further widgets depending on configuration.
///
///
/// [T] is the data type as held by the database. Type conversion is handled automatically within the *precept_client* package
///
/// [staticData] - if not null, the part is considered static and [isStatic] will return true.   See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation).
/// Takes precedence over [property].  This can be useful sometimes to temporarily display something while developing before data is available.
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [EditState] immediately above the [Part] Widget associated with this configuration.
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [EditState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [height] - is set here because both read and edit particles need to be the same height to avoid display 'jumping' when switching between read and edit modes.
/// [isStatic] - returns true if [staticData] is non-null
@JsonSerializable(explicitToJson: true)
class PPart extends PContent {
  final bool readOnly;
  final String? staticData;
  final PHelp? help;
  final String? tooltip;
  final double? height;
  final String readTraitName;
  final String? editTraitName;

  PPart(
      {String? caption,
      this.readOnly = false,
      this.height,
      String? property,
      this.readTraitName = '?',
      this.editTraitName = '?',
      this.staticData,
      this.help,
      ControlEdit controlEdit = ControlEdit.inherited,
      String? id,
      this.tooltip})
      : super(
          id: id,
          controlEdit: controlEdit,
          caption: caption,
          property: property,
        );

  factory PPart.fromJson(Map<String, dynamic> json) => _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);

  DebugNode get debugNode {
    final List<DebugNode> children = List.empty(growable: true);
    if (dataProviderIsDeclared) {
      DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) children.add(dn);
    }
    return DebugNode(this, children);
  }

  bool get isStatic => property == null;

  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (property == null && staticData == null) {
      collector.messages.add(ValidationMessage(
          item: this,
          msg:
              "a Part must either provide a 'property' to bind to data, or define 'staticData' to be presented"));
    }
  }
}
