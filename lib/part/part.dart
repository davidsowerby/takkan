// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/debug.dart';
import 'package:takkan_schema/common/message.dart';
import 'package:takkan_schema/util/walker.dart';

import '../script/content.dart';
import '../script/help.dart';
import '../script/script.dart';
import '../script/script_element.dart';

part 'part.g.dart';

/// Contained within a [Script] a [Part] describes a [Part], which presents the data for a single field.
///
/// A Part usually presents two different widgets, one for readOnly mode and one for edit mode.
///
/// More sophisticated Parts may present further widgets depending on configuration.
///
///
/// [T] is the data type as held by the database. Type conversion is handled automatically within the *takkan_client* package
///
/// [staticData] - used either on its own or combined with dynamic data. For example 'Welcome David' could be constructed from [staticData] of 'Welcome ' and 'David' from the logged in user's name. See [Localisation](https://www.takkanblog.co.uk/user-guide/takkan-model.html#localisation).
/// Takes precedence over [property].  For a full description of how to use static and dynamic data together, see:
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [EditState] immediately above the [Part] Widget associated with this configuration.
/// If [property] is null, [isStatic] will return true. For a full description of how to use static and dynamic data together, see:
/// [caption] - the text to display as a caption.  See [Localisation](https://www.takkanblog.co.uk/user-guide/takkan-model.html#localisation)
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [EditState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.takkanblog.co.uk/user-guide/takkan-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.takkanblog.co.uk/user-guide/takkan-model.html#localisation)
/// [height] - is set here because both read and edit particles need to be the same height to avoid display 'jumping' when switching between read and edit modes.
/// [isStatic] - returns true if [staticData] is non-null
@JsonSerializable(explicitToJson: true)
class Part extends Content {
  Part(
      {super.caption,
      this.readOnly = false,
      this.height,
      super.property,
      required this.traitName,
      this.staticData,
      this.help,
      super.controlEdit = ControlEdit.inherited,
      super.id,
      this.tooltip});

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
  final bool readOnly;
  final String? staticData;
  final Help? help;
  final String? tooltip;
  final double? height;
  final String traitName;

  @JsonKey(ignore: true)
  @override
  List<Object?> get props =>
      [...super.props, readOnly, height, traitName, staticData, help, tooltip];

  @override
  Map<String, dynamic> toJson() => _$PartToJson(this);

  @override
  DebugNode get debugNode {
    final List<DebugNode> children = List.empty(growable: true);
    if (dataProviderIsDeclared) {
      final DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) {
        children.add(dn);
      }
    }
    return DebugNode(this, children);
  }

  @override
  bool get isStatic => property == null;

  @override
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
