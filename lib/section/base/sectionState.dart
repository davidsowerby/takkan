import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/listBinding.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/section/base/section.dart';

/// Fulfils two functions, but is combined because both are usually required at the same time,
/// and would otherwise require two Provider 'tree-walks'
///
/// The first function is to provide an edit state available to all contained items:
///
/// - [canEdit] reflects whether the [readMode] status can be changed. If a [DocumentPageSection] is allowed to edit, this is
/// typically used to display an edit icon to the user
/// - [readMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
///
///
/// The second function is to hold a Binding and make it available to all contained items (see [Section] for an example).
/// The [parentSectionBinding] effectively creates a chain of bindings from the data source
///
/// The data for a section is represented either by a [MapBinding] - effectively an object representation, or a
/// [ListBinding], representing a collection of objects
/// - [index] is relevant only when [parentSectionBinding] is a list
/// - [parentSectionBinding] is null when this is a root of the [SectionState] tree
/// - [removalCallback] is set when a [SectionState] is the parent widget of a [PopoutSection], so that the [SectionList]
/// can be refreshed after an item has been removed
class SectionState with ChangeNotifier {
  final CollectionBinding _dataBinding;
  final int index;
  final Function() removalCallback;
  final isList;
  final SectionState parentSectionBinding;
  bool _canEdit;
  bool _readMode;

  SectionState(
      {@required CollectionBinding dataBinding,
      this.index,
      this.removalCallback,
      @required this.parentSectionBinding,
      @required bool canEdit,
      @required bool readOnly})
      : _dataBinding = dataBinding,
        isList = (dataBinding is ListBinding),
        _readMode = readOnly,
        _canEdit = canEdit,
        assert(dataBinding != null);

  CollectionBinding get dataBinding => _dataBinding;

  SectionState.fromDocumentState({@required DocumentState documentState})
      : _canEdit = documentState.canEdit,
        _readMode = documentState.readOnlyMode,
        _dataBinding = documentState.rootBinding,
        index = -1,
        parentSectionBinding = null,
        isList = false,
        removalCallback = null;

  SectionState.copy({@required SectionState source})
      : _dataBinding = source.dataBinding,
        index = source.index,
        removalCallback = source.removalCallback,
        isList = source.isList,
        parentSectionBinding = source.parentSectionBinding;

  bool get readMode {
    return _readMode;
  }

  bool get canEdit {
    return _canEdit;
  }

  set readMode(bool readOnly) {
    _readMode = readOnly;
    getLogger(this.runtimeType)
        .d("SectionEditState changed to readOnly: $readOnly");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }
}
