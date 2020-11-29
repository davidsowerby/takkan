import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/model/element.dart';
import 'package:precept_client/precept/model/help.dart';
import 'package:precept_client/precept/model/modelDocument.dart';
import 'package:precept_client/precept/model/style.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/partConverter.dart';
import 'package:precept_client/precept/schema/schema.dart';

part 'model.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class PModel {
  final List<PComponent> components;

  PModel({@required this.components});

  factory PModel.fromJson(Map<String, dynamic> json) => _$PModelFromJson(json);

  Map<String, dynamic> toJson() => _$PModelToJson(this);
}

@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent {
  final Map<String, PPart> parts;
  final String name;

  final List<PRoute> routes;

  PComponent({this.parts, @required this.routes, @required this.name});

  factory PComponent.fromJson(Map<String, dynamic> json) => _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute {
  final String path;
  final PPage page;

  PRoute({@required this.path, @required this.page});

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);
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
    bool isStatic=false,
  }) : _isStatic =isStatic;

  bool get isStatic => _isStatic || document.isStatic;

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  Map<String, dynamic> toJson() => _$PPageToJson(this);
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

@JsonSerializable(nullable: true, explicitToJson: true)
class PSection implements DisplayElement {
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<DisplayElement> elements;
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
    @required this.property,
    this.elements = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
    this.isStatic=false,
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
      {this.schema, this.documentSelector, @required this.sections, this.isStatic = false})
      : assert(isStatic || (documentSelector != null)),
        assert(isStatic || (schema != null)),
        assert((sections != null) && (sections.length > 0));

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);
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
