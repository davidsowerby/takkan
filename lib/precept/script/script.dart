import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/partConverter.dart';
import 'package:precept_client/precept/schema/schema.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/document.dart';
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

  PScript({@required this.components, PBackend backend, bool isStatic})
      : super(
          isStatic: isStatic,
          backend: backend,
        );

  factory PScript.fromJson(Map<String, dynamic> json) => _$PScriptFromJson(json);

  Map<String, dynamic> toJson() => _$PScriptToJson(this);

  @override
  @JsonKey(includeIfNull: false, nullable: true)
  PBackend get backend => _backend;
  bool get isStatic => _isStatic;

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

/// Holds common properties for every level of a [PScript], and provides methods to enable 'inheritance'
///
/// To save a lot of manual configuration, a number of properties can be set at higher level in the [PScript] structure,
/// and then overridden at a lower level.  For example, a [PBackend] may be set at [PScript] level, and then overridden
/// for one [PDocument]
///
/// Not all properties are appropriate to all levels, so some are ignored by descendant classes (for example, [backend]
/// cannot be set at [PPart] level.
///
/// There is one slight exception to this general principle. If [isStatic] is true at [PPart] level (either directly or inherited),
/// the data bindings to retrieve data must be created from [PDocument] level, as that is where the
/// root binding is created. A call to [validate] ensures that [PDocument] [isStatic] is set correctly
/// if any of its [PPart] instances require data.
///
/// **NOTE** Calls to any of the getters will fail unless [validate], because the [_parent] property
/// is set only after a [init] call.  Unfortunately there seems to be no way to
/// set this during construction - this also means that the [PScript] structure cannot be **const**
///
@JsonSerializable(nullable: false, explicitToJson: true)
class PCommon {

  PCommon _parent;
  bool _isStatic;
  PBackend _backend;

  PCommon({
    bool isStatic,
    PBackend backend,
  })  : _isStatic = isStatic,
        _backend = backend;

  bool get isStatic => _isStatic ?? parent.isStatic;

  @JsonKey(includeIfNull: false)
  PBackend get backend  {
   if (_backend == null){
     assert(_parent != null, "Have you forgotten to invoke PScript.init() ??");
     return _parent.backend;
   }else{
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
    bool isStatic = false,
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
    bool isStatic = false,
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

/// [isStatic] can be defined at either page or document level - it has the same effect
/// [pageKey] used to look up from [PageLibrary]
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage extends PCommon {
  final String title;
  final String pageKey;
  final PDocument document;
  final bool scrollable;

  @JsonKey(ignore: true)
  PPage({
    this.pageKey = Library.simpleKey,
    @required this.title,
    @required this.document,
    this.scrollable = true,
    bool isStatic = false,
    PBackend backend,
  }) : super(isStatic: isStatic);

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PRoute get parent => _parent;

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void validate(List<ValidationMessage> messages, int pass) {
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${parent.path ?? 'n/a'} must define a title"));
    }
    if (pageKey == null || pageKey.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${parent.path ?? 'n/a'} must define a pageKey"));
    }
    if (document == null) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${parent.path ?? 'n/a'} must define a document"));
    } else {
      document.validate(messages, pass);
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    document.doInit(this);
  }
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

@JsonSerializable(nullable: true, explicitToJson: true)
class PSection extends PCommon implements DisplayElement {
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> content;
  @JsonKey(ignore: true)
  final PSectionHeading heading;
  final String caption;
  final bool scrollable;
  final PHelp help;
  final String property;

  factory PSection.fromJson(Map<String, dynamic> json) => _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  PSection({
    this.property,
    this.content = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
    bool isStatic = false,
  }) : super(
          isStatic: isStatic,
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

/// if [isStatic] is true, [documentSelector] and [schema] are not required and may be null
/// if [isStatic] is false [documentSelector] and [schema] must be defined
/// [content] must always contain at least one [DisplayElement]
@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocument extends PCommon {
  final PDocumentSelector documentSelector;
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> content;
  final SDocument schema;

  @JsonKey(ignore: true)
  PDocument({
    this.schema,
    this.documentSelector,
    @required this.content,
    bool isStatic = false,
    PBackend backend,
  }) : super(
          isStatic: isStatic,
          backend: backend,
        );

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  PPage get parent => _parent;

  void validate(List<ValidationMessage> messages, int pass) {
    if (documentSelector == null) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: parent.title ?? 'untitled page',
          msg: "PDocument for ${parent.title} must define a documentSelector"));
    } else {
      documentSelector.validate(messages, pass);
    }
  }

  @override
  doInit(PCommon parent) {
    super.doInit(parent);
    for (var element in content) {
      (element as PCommon).doInit(this);
    }
    documentSelector.doInit(this);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PSectionHeading {
  final String title;
  final bool expandable;
  final bool openExpanded;
  final bool canEdit;
  final PHelp help;
  final PHeadingStyle style;

  PSectionHeading({
    @required this.title,
    this.expandable = true,
    this.openExpanded = true,
    this.canEdit = false,
    this.help,
    this.style = const PHeadingStyle(),
  }) : super();

  factory PSectionHeading.fromJson(Map<String, dynamic> json) => _$PSectionHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionHeadingToJson(this);
}
