import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/partConverter.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/data.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/style.dart';

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
    PBackend backend,
    Triple isStatic = Triple.inherited,
    PDataSource dataSource,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
  }) : super(
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
  Triple get isStatic => _isStatic;

  /// Validates the structure and content of the model
  List<ValidationMessage> validate() {
    init();
    final List<ValidationMessage> messages = List();

    if (components == null || components.length == 0) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: "n/a",
          msg: "A PScript instance must contain at least one component"));
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

class ValidationMessage {
  final String type;
  final String name;
  final String msg;

  ValidationMessage({@required Type type, @required this.name, @required this.msg})
      : type = type.toString();

  @override
  String toString() {
    return "$type : $name : $msg";
  }
}

///
/// Holds common properties for every level of a [PScript], and its main purpose is to reduce manual configuration.
/// Not all properties are appropriate to all levels (levels here means the level in the [PScript] structure).
///
/// Some properties work on the basis of 'inheritance'
/// For these properties, a higher level setting is used by all lower levels, unless overridden by a lower level setting:
///
/// - [backend]
/// - [dataSource]
/// - [isStatic] which if true, means a [Part] takes its data from the [PScript] and not a data source.
/// This also means that no [DataBinding] is needed.
///
/// /// If an inherited property has no value set anywhere in the hierarchy, the [PScript.validate] will flag an error
///
/// The following do not actually inherit a setting in quite the same way, but the value can be set at any level.
///
/// - [controlEdit] determines whether an editing action is displayed (usually a pencil icon).
/// It is only relevant if the user has permission to edit (see [EditState.canEdit]
/// A setting for [controlEdit] still overrides a setting higher up the hierarchy, but
/// has a number of possible settings defined by [ControlEdit], with the intention of making it
/// as easy as possible to specify what is wanted.  [hasEditControl] is computed during [PScript.init]
/// from the combination of [controlEdit] settings at different levels, and determines whether
/// a [Page], [Panel] or [Part] can trigger an edit.  It also deermines whether there is an associated [EditState] as shown in
/// the [User Guide](https://www.preceptblog.co.uk/user-guide/widget-tree.html)

///
/// **NOTE** Calls to any of the getters will fail unless [init] has been called first, because the [_parent] property
/// is set only after a [init] call.  Unfortunately there seems to be no way to
/// set this during construction - this also means that the [PScript] structure cannot be **const**
///
@JsonSerializable(nullable: false, explicitToJson: true)
@PDataSourceConverter()
class PCommon {
  @JsonKey(ignore: true)
  PCommon _parent;
  Triple _isStatic;
  bool _hasEditControl = false;
  final ControlEdit controlEdit;
  @JsonKey(nullable: true, includeIfNull: false)
  PBackend _backend;
  @JsonKey(nullable: true, includeIfNull: false)
  PDataSource _dataSource;

  PCommon({
    Triple isStatic = Triple.inherited,
    PBackend backend,
    PDataSource dataSource,
    this.controlEdit = ControlEdit.notSetAtThisLevel,
  })  : _isStatic = isStatic,
        _dataSource = dataSource,
        _backend = backend;

  Triple get isStatic => (_isStatic == Triple.inherited) ? parent.isStatic : _isStatic;

  bool get hasEditControl => _hasEditControl;

  @JsonKey(nullable: true, includeIfNull: false)
  PDataSource get dataSource => _dataSource ?? parent.dataSource;

  @JsonKey(nullable: true, includeIfNull: false)
  PBackend get backend {
    if (_backend == null) {
      assert(_parent != null, "Have you forgotten to invoke PScript.init() ??");
      return _parent.backend;
    } else {
      return _backend;
    }
  }

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

@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent extends PCommon {
  final String name;
  final List<PRoute> routes;

  @JsonKey(ignore: true)
  PComponent({
    this.routes = const [],
    @required this.name,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    Triple isStatic = Triple.inherited,
    PBackend backend,
  }) : super(
          isStatic: isStatic,
          backend: backend,
          controlEdit: controlEdit,
        );

  factory PComponent.fromJson(Map<String, dynamic> json) => _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);

  validate(List<ValidationMessage> messages, int index) {
    if (name == null || name.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: 'n/a',
          msg: "PComponent at index $index must have a name defined"));
    }
    if (routes == null || routes.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: (name == null || name.isEmpty) ? 'n/a' : name,
          msg: "PComponent at index $index must contain at least one PRoute"));
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
    Triple isStatic = Triple.inherited,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
    PBackend backend,
  }) : super(
          isStatic: isStatic,
          backend: backend,
          controlEdit: controlEdit,
        );

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);

  validate(PComponent parent, List<ValidationMessage> messages, int index) {
    final parentName = parent.name ?? 'unnamed';
    if (path == null || path.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: 'n/a',
          msg: "PRoute at index $index of PComponent $parentName must define a path"));
    }
    if (page == null) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: path ?? 'n/a',
          msg: "PRoute at index $index of PComponent $parentName must define a page"));
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
    this.pageType = Library.simpleKey,
    @required this.title,
    this.scrollable = true,
    Triple isStatic = Triple.inherited,
    this.content=const [],
    PBackend backend,
    PDataSource dataSource,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
  }) : super(
          isStatic: isStatic,
          dataSource: dataSource,
          backend: backend,
          controlEdit: controlEdit,
        );

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PRoute get parent => _parent;

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void validate(List<ValidationMessage> messages) {
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageType ?? 'n/a',
          msg: "PPage at PRoute ${parent.path ?? 'n/a'} must define a title"));
    }
    if (pageType == null || pageType.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageType ?? 'n/a',
          msg: "PPage at PRoute ${parent.path ?? 'n/a'} must define a pageType"));
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

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    this.property,
    this.content = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
    Triple isStatic = Triple.inherited,
    PBackend backend,
    PDataSource dataSource,
    ControlEdit controlEdit = ControlEdit.notSetAtThisLevel,
  }) : super(
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
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

enum Triple { yes, no, inherited }

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
