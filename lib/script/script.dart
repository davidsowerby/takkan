import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/debug.dart';
import 'package:precept_script/script/element.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/json/dataProviderConverter.dart';
import 'package:precept_script/script/json/queryConverter.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/query.dart';
import 'package:precept_script/script/style/style.dart';
import 'package:precept_script/script/style/writingStyle.dart';
import 'package:precept_script/validation/message.dart';

part 'script.g.dart';

/// The heart of Precept, this structure describes the the Widgets to use and their layout.
///
/// For more see the [overview](https://www.preceptblog.co.uk/user-guide/#overview) of the User Guide,
/// and the [detailed description](https://www.preceptblog.co.uk/user-guide/precept-script.html#introduction) of PScript
/// - [_scriptValidationMessages] are collected during the [validate] process
@JsonSerializable(nullable: false, explicitToJson: true)
class PScript extends PCommon {
  final String name;
  @JsonKey(nullable: true)
  final PBackend backend;
  final Map<String, PRoute> routes;
  final ConversionErrorMessages conversionErrorMessages;
  @JsonKey(ignore: true)
  final ValidationErrorMessages validationErrorMessages;
  @JsonKey(ignore: true)
  List<ValidationMessage> _scriptValidationMessages;
  @JsonKey(ignore: true)
  PDataProvider _defaultDataProvider;

  PScript({
    this.conversionErrorMessages = const ConversionErrorMessages(defaultConversionPatterns),
    this.validationErrorMessages = const ValidationErrorMessages(defaultValidationErrorMessages),
    this.routes = const {},
    this.name,
    this.backend,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    WritingStyle writingStyle = const WritingStyle(),
    ControlEdit controlEdit = ControlEdit.firstLevelPanels,
    String id,
  }) : super(
          id: id,
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          controlEdit: controlEdit,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
        );

  factory PScript.fromJson(Map<String, dynamic> json) => _$PScriptFromJson(json);

  Map<String, dynamic> toJson() => _$PScriptToJson(this);

  /// We have to override here, because the inherited getter looks to the parent - but now we do not have a parent
  @override
  @JsonKey(
      nullable: true,
      includeIfNull: false,
      fromJson: PDataProviderConverter.fromJson,
      toJson: PDataProviderConverter.toJson)
  PDataProvider get dataProvider => _dataProvider ?? _defaultDataProvider;

  @JsonKey(ignore: true)
  PDataProvider get defaultDataProvider => _defaultDataProvider;

  set defaultDataProvider(value) {
    _defaultDataProvider = value;
  }

  /// We have to override here, because the inherited getter looks to the parent - but now we do not have a parent
  @override
  @JsonKey(
      fromJson: PQueryConverter.fromJson,
      toJson: PQueryConverter.toJson,
      nullable: true,
      includeIfNull: false)
  PQuery get query => _query;

  /// We have to override these here, because the inherited getter looks to the parent - but now we do not have a parent
  IsStatic get isStatic => _isStatic;

  /// Validates the structure and content of the model
  /// If there are validation errors, throws a [PreceptException] if [throwOnFail] is true otherwise
  /// returns the list of validation messages
  List<ValidationMessage> validate(
      {bool throwOnFail = false, bool useCaptionsAsIds = true, bool logFailures = true}) {
    init(useCaptionsAsIds: useCaptionsAsIds);
    _scriptValidationMessages = List();
    doValidate(_scriptValidationMessages);

    if (routes == null || routes.length == 0) {
      _scriptValidationMessages
          .add(ValidationMessage(item: this, msg: "must contain at least one component"));
    } else {
      for (var entry in routes.entries) {
        if (entry.key.isEmpty) {
          _scriptValidationMessages
              .add(ValidationMessage(item: this, msg: "PRoute path cannot be an empty String"));
        }
        entry.value.doValidate(_scriptValidationMessages);
      }
    }

    if (conversionErrorMessages == null) {
      _scriptValidationMessages.add(ValidationMessage(
          item: this,
          msg:
              "conversionErrorMessages must be provided, they are required for data conversion error messages"));
    }

    if (validationErrorMessages == null) {
      _scriptValidationMessages.add(ValidationMessage(
          item: this,
          msg:
              "validationErrorMessages must be provided, they are required for data validation error messages"));
    }

    if (logFailures || throwOnFail) {
      final StringBuffer buf = StringBuffer();
      for (ValidationMessage message in _scriptValidationMessages) {
        buf.writeln(message.toString());
      }
      if (_scriptValidationMessages.isEmpty) {
        buf.writeln('No validation errors found in PScript $name');
      }
      if (throwOnFail && _scriptValidationMessages.isNotEmpty) {
        throw PreceptException(buf.toString());
      } else {
        logType(this.runtimeType).i(buf.toString());
      }
    }

    return _scriptValidationMessages;
  }

  /// Initialises the script by setting up a variety of variables which can be derived from those explicitly set by the user
  /// See the [doInit] call for each [PreceptItem} type
  ///
  /// If [useCaptionsAsIds] is true:  if [id] is not set, then the caption (or other property, as determined
  /// by each class) is treated as the [id].  See [PreceptItem.doInit] for the processing of ids, and
  /// each see the [doInit] call for each [PreceptItem} type for which property, if any, is used.
  init({bool useCaptionsAsIds = true}) {
    doInit(this, null, 0, useCaptionsAsIds: useCaptionsAsIds);
  }

  /// Passes call to all components, and sets the components names from their keys in parent
  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, null, 0);
    _setupControlEdit(ControlEdit.inherited);
    int i = 0;
    for (var entry in routes.entries) {
      entry.value._path = entry.key;

      /// This must be done first or validation messages get wrong debugId
      entry.value.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      i++;
    }
  }

  bool get failed => _scriptValidationMessages.length > 0;

  bool get passed => _scriptValidationMessages.length == 0;

  String get idAlternative => name;

  validationOutput() {
    StringBuffer buf = StringBuffer();
    buf.writeln('============================================================================');
    buf.writeln('=                        PScript Validation Failed                         =');
    buf.writeln('============================================================================');
    buf.writeAll(_scriptValidationMessages.map((e) => e.toString()), '\n');
    buf.writeln();
    buf.writeln('============================================================================');
    buf.writeln();
    print(buf.toString());
  }

  DebugNode get debugNode =>
      DebugNode(this, List.from(routes.entries.toList().map((e) => (e as PRoute).debugNode)));
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute extends PCommon {
  String _path;
  final PPage page;

  @JsonKey(ignore: true)
  PRoute({
    @required this.page,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    WritingStyle writingStyle = const WritingStyle(),
    ControlEdit controlEdit = ControlEdit.inherited,
  }) : super(
          isStatic: isStatic,
          dataProvider: dataProvider,
          controlEdit: controlEdit,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
        );

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);

  DebugNode get debugNode => DebugNode(this, [page.debugNode]);

  doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (_path == null || _path.isEmpty) {
      messages.add(ValidationMessage(item: this, msg: "must define a path"));
    }
    if (page == null) {
      messages.add(ValidationMessage(item: this, msg: "must define a page"));
    } else {
      page.doValidate(messages);
    }
  }

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    if (page != null) {
      page.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
    }
  }

  @override
  String get idAlternative => path;

  String get path => _path;
}

/// [pageType] is used to look up from [PageLibrary]
/// although [content] is a list, this simplest page only uses the first one
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage extends PContent {
  final String pageType;
  final bool scrollable;
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<PSubContent> content;

  @JsonKey(ignore: true)
  PPage({
    this.pageType = 'defaultPage',
    this.scrollable = true,
    IsStatic isStatic = IsStatic.inherited,
    this.content = const [],
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle=const PPanelStyle(),
    WritingStyle writingStyle=const WritingStyle(),
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
    String property,
    @required String title,
  }) : super(
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          id: id,
          property: property,
          caption: title,
        );

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PRoute get parent => super.parent as PRoute;

  DebugNode get debugNode {
    final List<DebugNode> children = content.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      children.add(dataProvider.debugNode);
    }
    if (queryIsDeclared) {
      children.add(query.debugNode);
    }
    return DebugNode(this, children);
  }

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: 'must define a title',
      ));
    }
    if (pageType == null || pageType.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: 'must define a pageType',
      ));
    }

    for (var element in content) {
      if (element is PCommon) {
        element.doValidate(messages);
      }
    }
  }

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    int i = 0;
    for (var element in content) {
      if (element is PPanel) {
        element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      }
      if (element is PPart) {
        element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      }
      i++;
    }
  }

  @override
  String get idAlternative => title;

  String get title => caption;

  /// [dataProvider] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get dataProviderIsDeclared => dataProvider != null;

  /// [query] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get queryIsDeclared => query != null;
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanel extends PSubContent {
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<PSubContent> content;
  @JsonKey(ignore: true)
  final PPanelHeading _heading;
  final bool openExpanded;
  final bool scrollable;
  final PHelp help;
  final String property;
  final PPanelStyle style;

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    this.openExpanded = true,
    this.property,
    this.content = const [],
    PPanelHeading heading,
    String caption,
    this.scrollable = false,
    this.help,
    this.style = const PPanelStyle(),
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle=const PPanelStyle(),
    WritingStyle writingStyle=const WritingStyle(),
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
  })  : _heading = heading ?? PPanelHeading(),
        super(
          id: id,
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
          caption: caption,
        );

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    if (heading != null) {
      heading.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
    }
    int i = 0;
    for (var element in content) {
      element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      i++;
    }
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    for (PSubContent element in content) {
      element.doValidate(messages);
    }
  }

  DebugNode get debugNode {
    final List<DebugNode> children = content.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      children.add(dataProvider.debugNode);
    }
    if (queryIsDeclared) {
      children.add(query.debugNode);
    }
    return DebugNode(this, children);
  }

  PPanelHeading get heading => _heading;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanelHeading extends PreceptItem {
  final bool expandable;
  final bool canEdit;
  final PHelp help;
  final PHeadingStyle style;

  PPanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    this.style = const PHeadingStyle(),
    String id,
  }) : super(id: id);

  factory PPanelHeading.fromJson(Map<String, dynamic> json) => _$PPanelHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelHeadingToJson(this);

  PPanel get parent => super.parent;
}

enum IsStatic { yes, no, inherited }

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
/// - [writingStyle] defines styles for all heading and text levels, derived from [ThemeData].  It would be called textStyle, but Flutter already uses that name
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
@JsonSerializable(nullable: false, explicitToJson: true)
class PCommon extends PreceptItem {
  IsStatic _isStatic;
  bool _hasEditControl = false;
  final ControlEdit controlEdit;
  @JsonKey(
      nullable: true,
      includeIfNull: false,
      fromJson: PDataProviderConverter.fromJson,
      toJson: PDataProviderConverter.toJson)
  PDataProvider _dataProvider;
  @JsonKey(ignore: true)
  PScript _script;
  @JsonKey(
      fromJson: PQueryConverter.fromJson,
      toJson: PQueryConverter.toJson,
      nullable: true,
      includeIfNull: false)
  PQuery _query;
  @JsonKey(nullable: true, includeIfNull: false)
  PPanelStyle _panelStyle;
  @JsonKey(nullable: true, includeIfNull: false)
  WritingStyle _writingStyle;

  PCommon({
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    this.controlEdit = ControlEdit.inherited,
    PSchema schema,
    String id,
  })  : _isStatic = isStatic,
        _dataProvider = dataProvider,
        _query = query,
        _panelStyle = panelStyle,
        _writingStyle = writingStyle,
        super(id: id);

  @JsonKey(ignore: true)
  IsStatic get isStatic => (_isStatic == IsStatic.inherited) ? parent.isStatic : _isStatic;

  bool get hasEditControl => _hasEditControl;

  PPanelStyle get panelStyle => _panelStyle;

  WritingStyle get writingStyle => _writingStyle;

  bool get inheritedEditControl {
    PCommon p = parent;
    while (p != null) {
      if (p.hasEditControl) {
        return true;
      }
      p = p.parent;
    }
    return false;
  }

  @JsonKey(ignore: true)
  PDataProvider get dataProvider => _dataProvider ?? parent.dataProvider;

  /// [dataProvider] is declared rather than inherited
  bool get dataProviderIsDeclared => (_dataProvider != null);

@JsonKey(ignore: true)
  PQuery get query => _query ?? parent.query;

  /// [query] is declared rather than inherited
  bool get queryIsDeclared => (_query != null);

  @JsonKey(ignore: true)
  PCommon get parent => super.parent as PCommon;

  @JsonKey(ignore: true)
  PScript get script => _script;

  /// Initialises by setting up [_parent], [_index] (by calling super) and [_hasEditControl] properties.
  /// If you override this to pass the call on to other levels, make sure you call super
  /// [inherited] is not just from the immediate parent - a [ControlEdit.panelsOnly] for example, could come from the [PScript] level
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    _script = script;
    PCommon p = parent;

    ControlEdit inherited = ControlEdit.inherited;
    while (p != null) {
      if (p.controlEdit != ControlEdit.inherited) {
        inherited = p.controlEdit;
        break;
      }
      p = p.parent;
    }
    _setupControlEdit(inherited);
    if (_dataProvider != null)
      _dataProvider.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
    if (_query != null) _query.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
  }

  /// [ControlEdit.noEdit] overrides everything
  _setupControlEdit(ControlEdit inherited) {
    // top levels are not visual elements
    if (this is PScript || this is PRoute) {
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

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (dataProvider != null) {
      dataProvider.doValidate(messages);
    }
    if (query != null) {
      query.doValidate(messages);
    }
  }
}

class PContent extends PCommon {
  final String caption;
  final String property;

  PContent({
    this.caption,
    this.property,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.inherited,
    PSchema schema,
    String id,
  }) : super(
          query: query,
          schema: schema,
          id: id,
          controlEdit: controlEdit,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          dataProvider: dataProvider,
          isStatic: isStatic,
        );
}
