import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/abstractListView.dart';

part 'listView.g.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a query
@JsonSerializable(nullable: true, explicitToJson: true)
class PListView extends PAbstractListView {
  static const String defaultReadTrait = 'list-read-default';
  static const String defaultEditTrait = 'list-edit-default';
  static const String defaultItemReadTrait = 'list-item-read-default';
  static const String defaultItemEditTrait = 'list-item-edit-default';
  final bool isQuery;
  final String titleProperty;
  final String subtitleProperty;
  final PListViewItemType itemType;

  PListView({
    this.isQuery = false,
    this.titleProperty = 'title',
    this.itemType = PListViewItemType.tile,
    this.subtitleProperty = 'subtitle',
    bool readOnly = false,
    IsStatic isStatic = IsStatic.inherited,
    double particleHeight,
    String caption,
    PHelp help,
    String staticData,
    @required String property,
    String readTraitName = defaultReadTrait,
    String editTraitName = defaultEditTrait,
    String tooltip,
    ControlEdit controlEdit = ControlEdit.inherited,
  }) : super(
          caption: caption,
          controlEdit: controlEdit,
          staticData: staticData,
          property: property,
          tooltip: tooltip,
          help: help,
          particleHeight: particleHeight,
          readOnly: readOnly,
          isStatic: isStatic,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
        );

  factory PListView.fromJson(Map<String, dynamic> json) => _$PListViewFromJson(json);

  Map<String, dynamic> toJson() => _$PListViewToJson(this);
}
