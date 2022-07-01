import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../data/provider/data_provider.dart';
import '../page/page.dart';
import '../panel/panel.dart';
import '../panel/static_panel.dart';
import '../part/part.dart';
import '../schema/schema.dart';
import 'script.dart';
import 'takkan_item.dart';

part 'common.g.dart';

enum IsReadOnly { yes, no, inherited }

/// [firstLevelPanels] can be set anywhere from {PPage] upwards, and enables edit control at the first level of Panels
/// [partsOnly] edit only at [Part] level (can be set higher up the hierarchy, even at [Script])
/// [panelsOnly] all panels from this level down (can be set higher up the hierarchy, even at [Script])
/// [thisOnly] enables edit for this instance only, overriding any inherited value
/// [noEdit] negates anything defined above
/// [inherited] accepts inherited value
enum ControlEdit {
  inherited,
  thisOnly,
  thisAndBelow,
  pagesOnly,
  panelsOnly,
  partsOnly,
  firstLevelPanels,
  noEdit,
}

///
/// Holds common properties for every level of a [Script], and its main purpose is to reduce manual configuration.
///
/// With the exception of [controlEdit] and[documentId] (described below), these properties are used to construct companion Widgets
/// in the [Widget Tree](https://www.takkanblog.co.uk/user-guide/widget-tree.html) as part of the build process.
/// In conjunction with Flutter and Provider, the resulting Widgets work on the basis of 'inheritance' - that is,
/// a higher level setting is used by all lower levels, unless overridden by a lower level setting.
///
/// [Script] and its constituents mimic this 'inheritance' structure for the purpose of validation.
///
/// - [dataProvider]
/// - [data-select]
/// - [textTrait] defines styles for all heading and text levels, derived from [ThemeData].  It would be called textStyle, but Flutter already uses that name
/// - [isStatic] which if true, means a [Part] takes its data from the [Script] and not a data source.
/// This also means that no [DataBinding] is needed.  Although this really only applies at [Part] level, it can be set
/// anywhere up to [Script] and take effect for all lower levels.
///
///
/// If an inherited property has no value set anywhere in the hierarchy, the [Script.validate] will flag an error
///
/// - [controlEdit] is treated slightly differently.
/// It determines whether an editing action is displayed (usually a pencil icon).
/// It is only relevant if the user has permission to edit (see [EditState.canEdit]).
/// A setting for [controlEdit] still overrides a setting higher up the hierarchy, but
/// has a number of possible settings defined by [ControlEdit], with the intention of making it
/// as easy as possible to specify what is wanted.  [hasEditControl] is computed during [Script.init]
/// from the combination of [controlEdit] settings at different levels, and determines whether
/// a [Page], [Panel] or [Part] can trigger an edit.  It also determines whether there is an associated [EditState] as shown in
/// the [User Guide](https://www.takkanblog.co.uk/user-guide/widget-tree.html)
///
/// - [documentId] combined with [objectId] are used to identify the item during validation, where no caption or title is defined.  It is also
/// used as a key in the corresponding, constructed Widget to aid functional testing.
///
/// - [script] provides a direct reference to the root [Script].  It is added during init
///
/// **NOTE** Calls to any of the getters will fail unless [init] has been called first, because the [_parent] property
/// is set only after a [init] call.  Unfortunately there seems to be no way to
/// set this during construction - this also means that the [Script] structure cannot be **const**
///
@JsonSerializable(explicitToJson: true)
class Common extends TakkanItem {
  Common({
    DataProvider? dataProvider,
    this.controlEdit = ControlEdit.inherited,
    super.id,
  })  : _dataProvider = dataProvider;

  bool _hasEditControl = false;
  final ControlEdit controlEdit;
  @protected
  final DataProvider? _dataProvider;

  bool get hasEditControl => _hasEditControl;

  bool get inheritedEditControl {
    Common p = parent;
    while (p is! NullTakkanItem) {
      if (p.hasEditControl) {
        return true;
      }
      p = p.parent;
    }
    return false;
  }

  @JsonKey(ignore: true)
  DataProvider? get dataProvider => _dataProvider ?? parent.dataProvider;

  /// [dataProvider] is declared rather than inherited
  bool get dataProviderIsDeclared => _dataProvider != null;

  @override
  @JsonKey(ignore: true)
  Common get parent => super.parent as Common;

  /// Initialises by setting up [_parent], [_index] (by calling super) and [_hasEditControl] properties.
  /// If you override this to pass the call on to other levels, make sure you call super
  /// [inherited] is not just from the immediate parent - a [ControlEdit.panelsOnly] for example, could come from the [Script] level
  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    TakkanItem p = parent;

    ControlEdit inherited = ControlEdit.inherited;
    while (p is! NullTakkanItem) {
      final Common p1 = p as Common;
      if (p1.controlEdit != ControlEdit.inherited) {
        inherited = p1.controlEdit;
        break;
      }
      p = p.parent;
    }
    setupControlEdit(inherited);
  }

  /// See [TakkanItem.subElements]
  @override
  List<Object> get subElements => [
        if (_dataProvider != null) _dataProvider!,
      ];

  /// [ControlEdit.noEdit] overrides everything
  void setupControlEdit(ControlEdit inherited) {
    // top levels are not visual elements
    if (this is Script) {
      _hasEditControl = false;
      return;
    }

    if (controlEdit == ControlEdit.noEdit) {
      _hasEditControl = false;
      return;
    }

    if ((controlEdit == ControlEdit.thisOnly) ||
        (controlEdit == ControlEdit.thisAndBelow)) {
      _hasEditControl = true;
      return;
    }

    if (inherited == ControlEdit.thisAndBelow) {
      _hasEditControl = true;
      return;
    }

    if (this is Part) {
      if (controlEdit == ControlEdit.partsOnly ||
          inherited == ControlEdit.partsOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (this is Panel || this is PanelStatic) {
      if (controlEdit == ControlEdit.panelsOnly ||
          inherited == ControlEdit.panelsOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (this is Page) {
      if (controlEdit == ControlEdit.pagesOnly ||
          inherited == ControlEdit.pagesOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (controlEdit == ControlEdit.firstLevelPanels ||
        inherited == ControlEdit.firstLevelPanels) {
      if ((this is Panel || this is PanelStatic) && parent is Page) {
        _hasEditControl = true;
        return;
      }
    }
  }
}

class NullTakkanItem extends Common {
  NullTakkanItem() : super();
}

class NullSchemaElement extends SchemaElement {
  NullSchemaElement() : super();
}
