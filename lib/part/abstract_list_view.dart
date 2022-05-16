import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/part.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a data-select
abstract class AbstractListView extends Part {
  static const String defaultReadTrait = 'list-read-default';
  static const String defaultEditTrait = 'list-edit-default';
  static const String defaultItemReadTrait = 'list-item-read-default';
  static const String defaultItemEditTrait = 'list-item-edit-default';
  final String titleProperty;
  final String subtitleProperty;

  AbstractListView({
    this.titleProperty = 'title',
    this.subtitleProperty = 'subtitle',
    bool readOnly = false,
    double? particleHeight,
    String? caption,
    Help? help,
    String? staticData,
    String? property,
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
          height: particleHeight,
          readOnly: readOnly,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
          id: pid,
        );
}

