import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/listBinding.dart';

/// Holds the binding for a section (see [Section] for an example)
/// The data for a section is represented either by a [MapBinding] - effectively an object representation, or a
/// [ListBinding], representing a collection of objects
/// [index] is relevant only when [asMapBinding] is a list entry, in other words the [parentSectionBinding] is a list
/// [parentSectionBinding] is null when this is a root of the [SectionBinding] tree
/// [removalCallback] is set when a [SectionBinding] is the parent widget of a [PopoutSection], so that the [SectionList]
/// can be refreshed after an item has been removed
class SectionBinding with ChangeNotifier {
  final CollectionBinding _dataBinding;
  final int index;
  final Function() removalCallback;
  final isList;
  final SectionBinding parentSectionBinding;

  SectionBinding({
    @required CollectionBinding dataBinding,
    this.index,
    this.removalCallback,
    @required this.parentSectionBinding,
  })  : _dataBinding = dataBinding,
        isList = (dataBinding is ListBinding),
        assert(dataBinding != null);

  CollectionBinding get dataBinding => _dataBinding;

  SectionBinding.copy({@required SectionBinding source})
      : _dataBinding = source.dataBinding,
        index = source.index,
        removalCallback = source.removalCallback,
        isList = source.isList,
        parentSectionBinding = source.parentSectionBinding;
}
