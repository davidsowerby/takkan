import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/part/part.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a data-select
abstract class AbstractListView extends Part {
  final String titleProperty;
  final String subtitleProperty;

  AbstractListView({
    this.titleProperty = 'title',
    this.subtitleProperty = 'subtitle',
    super.readOnly = false,
    super.height,
    super.caption,
    super.help,
    super.staticData,
    super.property,
    required super.traitName,
    super.tooltip,
    super.controlEdit = ControlEdit.inherited,
    super.id,
  });
}
