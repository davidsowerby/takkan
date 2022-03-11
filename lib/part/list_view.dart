import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/abstract_list_view.dart';

part 'list_view.g.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a data-select
@JsonSerializable(explicitToJson: true)
class PListView extends PAbstractListView {
  static const String defaultReadTrait = 'list-read-default';
  static const String defaultEditTrait = 'list-edit-default';
  static const String defaultItemReadTrait = 'list-item-read-default';
  static const String defaultItemEditTrait = 'list-item-edit-default';
  final bool isQuery;
  final String titleProperty;
  final String subtitleProperty;

  PListView({
    this.isQuery = false,
    this.titleProperty = 'title',
    this.subtitleProperty = 'subtitle',
    bool readOnly = false,
    double? particleHeight,
    String? caption,
    PHelp? help,
    String? staticData,
    required String property,
    String readTraitName = 'list-read-default',
    String editTraitName = 'list-edit-default',
    String? tooltip,
    ControlEdit controlEdit = ControlEdit.inherited,
    String? pid,
  }) : super(
          caption: caption,
          controlEdit: controlEdit,
          staticData: staticData,
          property: property,
          tooltip: tooltip,
          help: help,
          particleHeight: particleHeight,
          readOnly: readOnly,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
          pid: pid,
        );

  factory PListView.fromJson(Map<String, dynamic> json) =>
      _$PListViewFromJson(json);

  Map<String, dynamic> toJson() => _$PListViewToJson(this);
}
