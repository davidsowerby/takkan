import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/partConverter.dart';
import 'package:precept_client/precept/schema/schema.dart';
import 'package:precept_client/precept/script/document.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/style.dart';

part 'script.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class PScript {
  final List<PComponent> components;

  PScript({@required this.components});

  factory PScript.fromJson(Map<String, dynamic> json) => _$PScriptFromJson(json);

  Map<String, dynamic> toJson() => _$PScriptToJson(this);

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

  /// Expands any cascaded values
  ///
  /// Reduces the need for runtime checking by cascading properties such as 'isStatic'.  For example,
  /// if a PSection has its 'isStatic' property set true, all its constituent [PPart]s and sub-[PSection]s
  /// are also set to static
  expand() {}
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

@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent {
  final Map<String, PPart> parts;
  final String name;
  final bool isStatic;

  final List<PRoute> routes;

  PComponent({this.parts, @required this.routes, @required this.name, this.isStatic = false});

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
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute {
  final String path;
  final PPage page;

  PRoute({@required this.path, @required this.page});

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
      page.validate(this, messages, pass);
    }
  }
}

/// [isStatic] can be defined at either page or document level - it has the same effect
/// [pageKey] used to look up from [PageLibrary]
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage {
  final String title;
  final String pageKey;
  final PDocument document;
  final bool scrollable;
  final bool _isStatic;

  const PPage({
    this.pageKey = Library.defaultKey,
    @required this.title,
    @required this.document,
    this.scrollable = true,
    bool isStatic = false,
  }) : _isStatic = isStatic;

  bool get isStatic => _isStatic || document.isStatic;

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void validate(PRoute pRoute, List<ValidationMessage> messages, int pass) {
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${pRoute.path ?? 'n/a'} must define a title"));
    }
    if (pageKey == null || pageKey.isEmpty) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${pRoute.path ?? 'n/a'} must define a pageKey"));
    }
    if (document == null) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pageKey ?? 'n/a',
          msg: "PPage at PRoute ${pRoute.path ?? 'n/a'} must define a document"));
    } else {
      document.validate(this, messages, pass);
    }
  }
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

@JsonSerializable(nullable: true, explicitToJson: true)
class PSection implements DisplayElement {
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> content;
  @JsonKey(ignore: true)
  final PSectionHeading heading;
  final String caption;
  final bool scrollable;
  final PHelp help;
  final String property;
  final bool isStatic;

  factory PSection.fromJson(Map<String, dynamic> json) => _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  const PSection({
    this.property,
    this.content = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
    this.isStatic = false,
  });
}

/// if [isStatic] is true, [documentSelector] and [schema] are not required and may be null
/// if [isStatic] is false [documentSelector] and [schema] must be defined
/// [sections] must always contain at least one [PSection]
@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocument {
  final PDocumentSelector documentSelector;
  final bool isStatic;
  final List<PSection> sections;
  final SDocument schema;

  const PDocument(
      {this.schema, this.documentSelector, @required this.sections, this.isStatic = false});

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  void validate(PPage pPage, List<ValidationMessage> messages, int pass) {
    if (documentSelector == null) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: pPage.title ?? 'untitled page',
          msg: "PDocument for ${pPage.title} must define a documentSelector"));
    } else {
      documentSelector.validate(this, messages, pass);
    }
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
