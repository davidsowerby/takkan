// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import '../script/script_element.dart';
import '../script/takkan_element.dart';
import 'part.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a data-select
abstract class AbstractListView extends Part {
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
  final String titleProperty;
  final String subtitleProperty;

  @override
  List<Object?> get props => [...super.props,titleProperty,subtitleProperty];
}
