import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/element.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/json/dataSourceConverter.dart';
import 'package:precept_script/script/json/partConverter.dart';
import 'package:precept_script/script/panelStyle.dart';
import 'package:precept_script/script/part/pPart.dart';
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
@JsonSerializable(nullable: false, explicitToJson: true)
class PScript extends PCommon {
  final List<PComponent> components;

  PScript({
    this.components = const [],
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id = 'script',
  }) : super(
          id: id,
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          controlEdit: controlEdit,
        );

  factory PScript.fromJson(Map<String, dynamic> json) => _$PScriptFromJson(json);

  Map<String, dynamic> toJson() => _$PScriptToJson(this);

  /// We have to override here, because the inherited getter looks to the parent - but now we do not have a parent
  @override
  @JsonKey(includeIfNull: false, nullable: true)
  PBackend get backend => _backend;

  /// We have to override here, because the inherited getter looks to the parent - but now we do not have a parent
  @override
  @JsonKey(includeIfNull: false, nullable: true)
  PDataSource get dataSource => _dataSource;

  /// We have to override these here, because the inherited getter looks to the parent - but now we do not have a parent
  IsStatic get isStatic => _isStatic;

  /// Validates the structure and content of the model
  List<ValidationMessage> validate() {
    init();
    final List<ValidationMessage> messages = List();

    if (components == null || components.length == 0) {
      messages.add(ValidationMessage(item: this, msg: "must contain at least one component"));
    } else {
      var index = 0;
      for (var component in components) {
        component.validate(messages, index);
        index++;
      }
    }
    return messages;
  }

  init() {
    doInit(null);
  }

  @override
  doInit(PCommon parent) {
    _setupControlEdit(ControlEdit.notSetAtThisLevel);
    for (var component in components) {
      component.doInit(this);
    }
  }
}







@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent extends PCommon {
  final String name;
  final List<PRoute> routes;

  @JsonKey(ignore: true)
  PComponent({
    this.routes = const [],
    @required this.name,
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
  }) : super(
          id: name ?? id,
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
        );

  factory PComponent.fromJson(Map<String, dynamic> json) => _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);

  validate(List<ValidationMessage> messages, int index) {
    if (name == null || name.isEmpty) {
      messages.add(ValidationMessage(
          item: this, msg: "PComponent at index $index must have a name defined"));
    }
    if (routes == null || routes.isEmpty) {
      messages.add(ValidationMessage(
          item: this, msg: "PComponent at index $index must contain at least one PRoute"));
    } else {
      int index = 0;
      for (var route in routes) {
        route.validate(this, messages, index);
        index++;
      }
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    for (var route in routes) {
      route.doInit(this);
    }
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute extends PCommon {
  final String path;
  final PPage page;

  @JsonKey(ignore: true)
  PRoute({
    @required this.path,
    @required this.page,
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
  }) : super(
          isStatic: isStatic,
          backend: backend,
          controlEdit: controlEdit,
        );

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);

  validate(PComponent parent, List<ValidationMessage> messages, int index) {
    final parentName = parent.itemId;
    if (path == null || path.isEmpty) {
      messages.add(ValidationMessage(
          item: this, msg: "at index $index of PComponent $parentName must define a path"));
    }
    if (page == null) {
      messages.add(ValidationMessage(
          item: this, msg: "at index $index of PComponent $parentName must define a page"));
    } else {
      page.validate(messages);
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    if (page != null) {
      page.doInit(this);
    }
  }
}

/// [pageType] is used to look up from [PageLibrary]
/// although [content] is a list, this simplest page only uses the first one
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage extends PCommon {
  final String title;
  final String pageType;
  final bool scrollable;
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> content;

  @JsonKey(ignore: true)
  PPage({
    this.pageType = 'defaultPage',
    @required this.title,
    this.scrollable = true,
    IsStatic isStatic = IsStatic.inherited,
    this.content = const [],
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
  }) : super(
            isStatic: isStatic,
            backend: backend,
            dataSource: dataSource,
            panelStyle: panelStyle,
            writingStyle: writingStyle,
            controlEdit: controlEdit,
            id: title ?? id);

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PRoute get parent => _parent;

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void validate(List<ValidationMessage> messages) {
    final routePath = parent.path;
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: "PPage at route $routePath must define a title",
      ));
    }
    if (pageType == null || pageType.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: "PPage at route $routePath must define a pageType",
      ));
    }

    if (isStatic != IsStatic.yes) {
      if (backend == null) {
        messages.add(ValidationMessage(
            item: this,
            msg: "PPage at route $routePath must either be static or have a backend defined"));
      }
      if (dataSource == null) {
        messages.add(ValidationMessage(
            item: this,
            msg: "PPage at route $routePath must either be static or have a dataSource defined"));
      }
    }
    for (var element in content) {
      if (element is PPanel) {
        element.validate(messages);
      }
      if (element is PPart){
        element.validate(messages);
      }
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    for (var element in content) {
      if (element is PPanel) {
        element.doInit(this);
      }
      if (element is PPart) {
        element.doInit(this);
      }
    }
  }

  /// Unless a page is declared as static ([isStatic] == [IsStatic.yes]), [backend] is always
  /// considered 'declared' by the page, even when actually declared by something above it.
  /// This is because a page is the first level to be actually built into the Widget tree
   bool get backendIsDeclared => (isStatic==IsStatic.yes) ? false : true;

  /// Unless a page is declared as static ([isStatic] == [IsStatic.yes]), [dataSource] is always
  /// considered 'declared' by the page, even when actually declared by something above it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get dataSourceIsDeclared => (isStatic==IsStatic.yes) ? false : true;
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanel extends PCommon implements DisplayElement {
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> content;
  @JsonKey(ignore: true)
  final PPanelHeading heading;
  final String caption;
  final bool scrollable;
  final PHelp help;
  final String property;
  final PPanelStyle style;

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    this.property,
    this.content = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
    this.style=const PPanelStyle(),
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
  }) : super(
          id: id,
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
          panelStyle: panelStyle,
          writingStyle: writingStyle,
          controlEdit: controlEdit,
        );

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    for (var element in content) {
      final entry = element as PCommon;
      entry.doInit(this);
    }
  }

  String get id => caption ?? itemId;

  void validate(List<ValidationMessage> messages) {
    if (isStatic != IsStatic.yes) {
      if (backend == null) {
        messages.add(
            ValidationMessage(item: this, msg: "must either be static or have a backend defined"));
      }
      if (dataSource == null) {
        messages.add(ValidationMessage(
            item: this, msg: "must either be static or have a dataSource defined"));
      }
    }
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanelHeading {
  final String title;
  final bool expandable;
  final bool openExpanded;
  final bool canEdit;
  final PHelp help;
  final PHeadingStyle style;

  PPanelHeading({
    @required this.title,
    this.expandable = true,
    this.openExpanded = true,
    this.canEdit = false,
    this.help,
    this.style = const PHeadingStyle(),
  }) : super();

  factory PPanelHeading.fromJson(Map<String, dynamic> json) => _$PPanelHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelHeadingToJson(this);
}

enum IsStatic { yes, no, inherited }

/// [firstLevelPanels] can be set anywhere from {PPage] upwards, and enables edit control at the first level of Panels
/// [partsOnly] edit only at [Part] level (can be set higher up the hierarchy, even at [PScript])
/// [panelsOnly] all panels from this level down (can be set higher up the hierarchy, even at [PScript])
/// [thisOnly] enables edit for this instance only, overriding any inherited value
/// [noEdit] cancels anything defined above (effectively the opposite of [thisOnly])
/// [notSetAtThisLevel] accepts inherited value
enum ControlEdit {
  notSetAtThisLevel,
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
/// - [backend]
/// - [dataSource]
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
/// **NOTE** Calls to any of the getters will fail unless [init] has been called first, because the [_parent] property
/// is set only after a [init] call.  Unfortunately there seems to be no way to
/// set this during construction - this also means that the [PScript] structure cannot be **const**
///
@JsonSerializable(nullable: false, explicitToJson: true)
@PDataSourceConverter()
class PCommon extends PreceptItem {
  @JsonKey(ignore: true)
  PCommon _parent;
  IsStatic _isStatic;
  bool _hasEditControl = false;
  final ControlEdit controlEdit;
  @JsonKey(nullable: true, includeIfNull: false)
  PBackend _backend;
  @JsonKey(nullable: true, includeIfNull: false)
  PDataSource _dataSource;
  @JsonKey(nullable: true, includeIfNull: false)
  PPanelStyle _panelStyle;
  @JsonKey(nullable: true, includeIfNull: false)
  WritingStyle _writingStyle;

  PCommon({
    IsStatic isStatic = IsStatic.inherited,
    PBackend backend,
    PDataSource dataSource,
    PPanelStyle panelStyle,
    WritingStyle writingStyle,
    this.controlEdit = ControlEdit.notSetAtThisLevel,
    String id,
  })  : _isStatic = isStatic,
        _backend = backend,
        _dataSource = dataSource,
        _panelStyle = panelStyle,
        _writingStyle = writingStyle,
        super(itemId: id);

  IsStatic get isStatic => (_isStatic == IsStatic.inherited) ? parent.isStatic : _isStatic;

  bool get hasEditControl => _hasEditControl;

  @JsonKey(nullable: true, includeIfNull: false)
  PBackend get backend => _backend ?? parent.backend;

  /// [backend] is declared rather than inherited
  bool get backendIsDeclared => (_backend != null);

  @JsonKey(nullable: true, includeIfNull: false)
  PDataSource get dataSource => _dataSource ?? parent.dataSource;

  /// [dataSource] is declared rather than inherited
  bool get dataSourceIsDeclared => (_dataSource != null);

  @JsonKey(ignore: true)
  PCommon get parent => _parent;

  /// Initialises by setting up [_parent] and [_hasEditControl] properties.
  /// If you override this to pass the call on to other levels, make sure you call super
  /// [inherited] is not just from the immediate parent - a [ControlEdit.panelsOnly] for example, could come from the [PScript] level
  doInit(PCommon parent) {
    _parent = parent;
    PCommon p = parent;
    ControlEdit inherited = ControlEdit.notSetAtThisLevel;
    while (p != null) {
      if (p.controlEdit != ControlEdit.notSetAtThisLevel) {
        inherited = p.controlEdit;
        break;
      }
      p = p.parent;
    }
    _setupControlEdit(inherited);
  }

  /// [ControlEdit.noEdit] overrides everything
  _setupControlEdit(ControlEdit inherited) {
    // top levels are not visual elements
    if (this is PScript || this is PComponent || this is PRoute) {
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
      if (this is PPanel && _parent is PPage) {
        _hasEditControl = true;
        return;
      }
    }
  }
}