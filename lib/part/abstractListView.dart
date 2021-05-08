import 'package:flutter/foundation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/part.dart';


/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a query
abstract class PAbstractListView extends PPart {
  static const String defaultReadTrait = 'list-read-default';
  static const String defaultEditTrait = 'list-edit-default';
  static const String defaultItemReadTrait = 'list-item-read-default';
  static const String defaultItemEditTrait = 'list-item-edit-default';
  final String titleProperty;
  final String subtitleProperty;
  final PListViewItemType itemType;

  PAbstractListView({
    this.titleProperty='title',
    this.itemType=PListViewItemType.tile,
    this.subtitleProperty='subtitle',
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
          height: particleHeight,
          readOnly: readOnly,
          isStatic: isStatic,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
        );


}

enum PListViewItemType {tile, navTile, panel}