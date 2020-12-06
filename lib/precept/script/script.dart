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
import 'package:provider/provider.dart';

part 'script.g.dart';

/// The heart of Precept, this structure describes the the Widgets to use and their layout.
///
/// For more see the [overview](https://www.preceptblog.co.uk/user-guide/#overview) of the User Guide,
/// and the [detailed description](https://www.preceptblog.co.uk/user-guide/precept-script.html#introduction) of PScript
@JsonSerializable(nullable: false, explicitToJson: true)
class PScript extends PCommon {
  final List<PComponent> components;

  PScript({@required this.components, PBackend backend, bool isStatic, PDataSource dataSource})
      : super(
          isStatic: isStatic,
          backend: backend,
          dataSource: dataSource,
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
  bool get isStatic => _isStatic;
  bool get controlEdit => _controlEdit;

  /// Validates the structure and content of the model
  ///
  /// Uses 2 passes.  The first does not check anything which involves cascaded values (for example
  /// 'isStatic') because those checks need [expand] to be run first
  List<ValidationMessage> validate() {
    int pass = 1;
    final List<ValidationMessage> messages = List();

    if (components == null || components.length == 0) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: "n/a",
          msg: "A PScript instance must contain at least one component"));
    } else {
      var index = 0;
      for (var component in components) {
        component.validate(messages, pass, index);
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
/// Some operate on an 'overrule' basis, where a higher level setting overrules a lower level setting:
///
/// - [controlEdit] determines whether an editing action is displayed at this level, and applies only
/// to [PPage], [PPanel] and [PPart]. It determines whether an [EditState] is used for this [Part].
/// Defaults to true, if nothing above it true.
///
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
  bool _isStatic;
  bool _controlEdit;
  @JsonKey(nullable: true, includeIfNull: false)
  PBackend _backend;
  @JsonKey(nullable: true, includeIfNull: false)
  PDataSource _dataSource;

  PCommon({
    bool isStatic,
    PBackend backend,
    PDataSource dataSource,
    bool controlEdit,
  })  : _isStatic = isStatic,
        _controlEdit = controlEdit,
        _dataSource = dataSource,
        _backend = backend;

  bool get isStatic => _isStatic ?? parent.isStatic;

  /// Walks up the tree as far as [PPage] (one below [PRoute] and returns false if any level above is true
  /// This is the 'override' mechanism, where a higher level declaring true overrides all lower levels
  bool get controlEdit {
    PCommon p=parent;
    while (!(p is PRoute)){
      if (p.controlEdit==null) return false;
      if (p.controlEdit) return false;
      p=p.parent;
    }
    return _controlEdit ?? false;
  }

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

  /// Initialises by setting up parent properties.  If you override this to pass the call on to other
  /// levels, make sure you call super
  doInit(PCommon parent) {
    _parent = parent;
  }
}

@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent extends PCommon {
  final String name;
  final List<PRoute> routes;

  @JsonKey(ignore: true)
  PComponent({
    @required this.routes,
    @required this.name,
    bool isStatic,
    PBackend backend,
  }) : super(
          isStatic: isStatic,
          backend: backend,
        );

  factory PComponent.fromJson(Map<String, dynamic> json) => _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);

  validate(List<ValidationMessage> messages, int pass, int index) {
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
        route.validate(this, messages, pass, index);
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
    bool isStatic,
    PBackend backend,
  }) : super(
          isStatic: isStatic,
          backend: backend,
        );

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);

  validate(PComponent parent, List<ValidationMessage> messages, int pass, int index) {
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
      page.validate(messages, pass);
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    page.doInit(this);
  }
}

/// [pageType] is used to look up from [PageLibrary]
/// although [panels] is a list, this simplest page only uses the first one
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage extends PCommon {
  final String title;
  final String pageType;
  final bool scrollable;
  final List<PPanel> panels;

  @JsonKey(ignore: true)
  PPage({
    this.pageType = Library.simpleKey,
    @required this.title,
    this.scrollable = true,
    bool isStatic,
    this.panels,
    PBackend backend,
    PDataSource dataSource,
    bool controlEdit,
  }) : super(
          isStatic: isStatic,
          dataSource: dataSource,
          backend: backend,
          controlEdit: controlEdit,
        );

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PRoute get parent => _parent;

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void validate(List<ValidationMessage> messages, int pass) {
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
    for (var panel in panels) {
      panel.doInit(this);
    }
  }

  Widget build() {
    final List<Widget> children = List();
    for (var panel in panels) {
      children.add(panel.build());
    }
    return (scrollable) ? ListView(children: children) : Column(children: children);
  }

  bool get controlEdit => _controlEdit ?? false;
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
    bool isStatic,
    PBackend backend,
    PDataSource dataSource,
    bool controlEdit,
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

  Widget build() {
    final List<Widget> children = List();
    for (var element in content) {
      Widget child;
      if (element is PPanel) {
        child = element.build();
      }
      if (element is PPart) {
        child = element.build();
      }
      children.add(ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: child));
    }
    return (scrollable) ? ListView(children: children) : Column(children: children);
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
