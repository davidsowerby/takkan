import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/data/provider/dataProviderConverter.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/queryConverter.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/trait/textTrait.dart';
import 'package:precept_script/validation/message.dart';

part 'common.g.dart';

enum IsStatic { yes, no, inherited }
enum IsReadOnly { yes, no, inherited }

/// [firstLevelPanels] can be set anywhere from {PPage] upwards, and enables edit control at the first level of Panels
/// [partsOnly] edit only at [Part] level (can be set higher up the hierarchy, even at [PScript])
/// [panelsOnly] all panels from this level down (can be set higher up the hierarchy, even at [PScript])
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
/// Holds common properties for every level of a [PScript], and its main purpose is to reduce manual configuration.
///
/// With the exception of [controlEdit] and[documentId] (described below), these properties are used to construct companion Widgets
/// in the [Widget Tree](https://www.preceptblog.co.uk/user-guide/widget-tree.html) as part of the build process.
/// In conjunction with Flutter and Provider, the resulting Widgets work on the basis of 'inheritance' - that is,
/// a higher level setting is used by all lower levels, unless overridden by a lower level setting.
///
/// [PScript] and its constituents mimic this 'inheritance' structure for the purpose of validation.
///
/// - [dataProvider]
/// - [query]
/// - [textTrait] defines styles for all heading and text levels, derived from [ThemeData].  It would be called textStyle, but Flutter already uses that name
/// - [panelStyle] defines borders and other styling for panels
/// - [isStatic] which if true, means a [Part] takes its data from the [PScript] and not a data source.
/// This also means that no [DataBinding] is needed.  Although this really only applies at [Part] level, it can be set
/// anywhere up to [PScript] and take effect for all lower levels.
///
///
/// If an inherited property has no value set anywhere in the hierarchy, the [PScript.validate] will flag an error
///
/// - [controlEdit] is treated slightly differently.
/// It determines whether an editing action is displayed (usually a pencil icon).
/// It is only relevant if the user has permission to edit (see [EditState.canEdit]).
/// A setting for [controlEdit] still overrides a setting higher up the hierarchy, but
/// has a number of possible settings defined by [ControlEdit], with the intention of making it
/// as easy as possible to specify what is wanted.  [hasEditControl] is computed during [PScript.init]
/// from the combination of [controlEdit] settings at different levels, and determines whether
/// a [Page], [Panel] or [Part] can trigger an edit.  It also determines whether there is an associated [EditState] as shown in
/// the [User Guide](https://www.preceptblog.co.uk/user-guide/widget-tree.html)
///
/// - [documentId] combined with [itemId] are used to identify the item during validation, where no caption or title is defined.  It is also
/// used as a key in the corresponding, constructed Widget to aid functional testing.
///
/// - [script] provides a direct reference to the root [PScript].  It is added during init
///
/// **NOTE** Calls to any of the getters will fail unless [init] has been called first, because the [_parent] property
/// is set only after a [init] call.  Unfortunately there seems to be no way to
/// set this during construction - this also means that the [PScript] structure cannot be **const**
///
@JsonSerializable(explicitToJson: true)
class PCommon extends PreceptItem {
  IsStatic _isStatic;
  bool _hasEditControl = false;
  final ControlEdit controlEdit;
  @JsonKey(
      includeIfNull: false,
      fromJson: PDataProviderConverter.fromJson,
      toJson: PDataProviderConverter.toJson)
  PDataProviderBase? _dataProvider;
  @JsonKey(ignore: true)
  PScript? _script;
  @JsonKey(fromJson: PQueryConverter.fromJson, toJson: PQueryConverter.toJson, includeIfNull: false)
  PQuery? _query;

  PCommon({
    IsStatic isStatic = IsStatic.inherited,
    PDataProviderBase? dataProviderConfig,
    PQuery? query,
    PTextTrait? textTrait,
    this.controlEdit = ControlEdit.inherited,
    PSchema? schema,
    String? id,
  })
      : _isStatic = isStatic,
        _dataProvider = dataProviderConfig,
        _query = query,
        super(id: id);

  @JsonKey(ignore: true)
  IsStatic get isStatic => (_isStatic == IsStatic.inherited) ? parent.isStatic : _isStatic;

  /// To give descendant access to private field without messing up property cascading
  IsStatic getIsStatic() {
    return _isStatic;
  }

  bool get hasEditControl => _hasEditControl;


  bool get inheritedEditControl {
    PCommon p = parent;
    while (!(p is NullPreceptItem)) {
      if (p.hasEditControl) {
        return true;
      }
      p = p.parent;
    }
    return false;
  }

  @JsonKey(ignore: true)
  PDataProviderBase? get dataProvider => _dataProvider ?? parent.dataProvider;

  /// [dataProvider] is declared rather than inherited
  bool get dataProviderIsDeclared => (_dataProvider != null);

  @JsonKey(ignore: true)
  PQuery? get query => _query ?? parent.query;

  /// To give descendant access to private field without messing up property cascading
  PQuery? getQuery() {
    return _query;
  }

  /// [query] is declared rather than inherited
  bool get queryIsDeclared => (_query != null);

  @JsonKey(ignore: true)
  PCommon get parent => super.parent as PCommon;

  @JsonKey(ignore: true)
  PScript? get script => _script;

  /// Initialises by setting up [_parent], [_index] (by calling super) and [_hasEditControl] properties.
  /// If you override this to pass the call on to other levels, make sure you call super
  /// [inherited] is not just from the immediate parent - a [ControlEdit.panelsOnly] for example, could come from the [PScript] level
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    _script = script;
    PreceptItem p = parent;

    ControlEdit inherited = ControlEdit.inherited;
    while (!(p is NullPreceptItem)) {
      final PCommon p1=p as PCommon;
      if (p1.controlEdit != ControlEdit.inherited) {
        inherited = p1.controlEdit;
        break;
      }
      p = p.parent;
    }
    setupControlEdit(inherited);
    if (_dataProvider != null)
      _dataProvider?.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
    if (_query != null) _query?.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
  }

  /// [ControlEdit.noEdit] overrides everything
  setupControlEdit(ControlEdit inherited) {
    // top levels are not visual elements
    if (this is PScript ) {
      _hasEditControl = false;
      return;
    }

    if (controlEdit == ControlEdit.noEdit) {
      _hasEditControl = false;
      return;
    }

    if ((controlEdit == ControlEdit.thisOnly) || (controlEdit == ControlEdit.thisAndBelow)) {
      _hasEditControl = true;
      return;
    }

    if (inherited == ControlEdit.thisAndBelow) {
      _hasEditControl = true;
      return;
    }

    if (this is PPart) {
      if (controlEdit == ControlEdit.partsOnly || inherited == ControlEdit.partsOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (this is PPanel) {
      if (controlEdit == ControlEdit.panelsOnly || inherited == ControlEdit.panelsOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (this is PPage) {
      if (controlEdit == ControlEdit.pagesOnly || inherited == ControlEdit.pagesOnly) {
        _hasEditControl = true;
        return;
      }
    }

    if (controlEdit == ControlEdit.firstLevelPanels || inherited == ControlEdit.firstLevelPanels) {
      if (this is PPanel && parent is PPage) {
        _hasEditControl = true;
        return;
      }
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (_query != null) _query?.walk(visitors);
    if (_dataProvider != null) _dataProvider?.walk(visitors);
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (dataProvider != null) {
      dataProvider?.doValidate(messages);
    }
    if (query != null) {
      query?.doValidate(messages);
    }
  }
}


class NullPreceptItem extends PCommon{

  NullPreceptItem() : super();

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, NullPreceptItem(), index);
  }

}
