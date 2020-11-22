import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/help.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/model/style.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/partConverter.dart';
import 'package:precept/precept/schema/schema.dart';

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

@JsonSerializable(nullable: true, explicitToJson: true)
/// [pageKey] used to look up from [PageLibrary]
class PPage {
  final String title;
  final String pageKey;
  final PDocument document;

  const PPage( {@required this.pageKey,
    @required this.title,
    @required this.document,
  });

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

  factory PSection.fromJson(Map<String, dynamic> json) => _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  const PSection({
    @required this. property,
    this.elements = const [],
    this.heading,
    this.caption,
    this.scrollable = false,
    this.help,
  });
}

@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocument {
  final PDocumentSelector documentSelector;
  final List<PSection> sections;

  const PDocument(
      {@required SDocument schema, @required this.documentSelector, @required this.sections});

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
