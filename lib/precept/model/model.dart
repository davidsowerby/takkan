import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/help.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/model/style.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/partConverter.dart';

part 'model.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class PreceptModel {
  final List<PComponent> components;

  PreceptModel({@required this.components});

  factory PreceptModel.fromJson(Map<String, dynamic> json) =>
      _$PreceptModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreceptModelToJson(this);
}

@JsonSerializable(nullable: false, explicitToJson: true)
@PPartMapConverter()
class PComponent {
  final Map<String, PPart> parts;
  final String name;

  final List<PRoute> routes;

  PComponent({this.parts, @required this.routes, @required this.name});

  factory PComponent.fromJson(Map<String, dynamic> json) =>
      _$PComponentFromJson(json);

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
class PPage {
  final String title;

  // final pageType;
  @JsonKey(
      fromJson: PElementListConverter.fromJson,
      toJson: PElementListConverter.toJson)
  final List<DisplayElement> elements;

  PPage({
    @required this.title,
    @required this.elements,
    // this.pageType = PageType.standard
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
  @JsonKey(
      fromJson: PElementListConverter.fromJson,
      toJson: PElementListConverter.toJson)
  final List<DisplayElement> elements;

  final PSectionHeading heading;
  final String property;
  final String caption;
  final bool scrollable;
  final PHelp help;

  factory PSection.fromJson(Map<String, dynamic> json) =>
      _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  const PSection({
    this.elements = const [],
    this.heading,
    this.caption,
    @required this.property,
    this.scrollable = false,
    this.help,
  });
}

@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocument extends PSection {
  final PDocumentSelector documentSelector;

  const PDocument(
      {@required
          this.documentSelector,
      @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
          List<DisplayElement> elements = const [],
      PSectionHeading heading,
      String property = "not required",
      bool partsFirst = true})
      : super(
          elements: elements,
          heading: heading,
          property: property,
        );

  factory PDocument.fromJson(Map<String, dynamic> json) =>
      _$PDocumentFromJson(json);

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
    this.canEdit=false,
    this.help,
    this.style=const PHeadingStyle(),
  }) : super();

  factory PSectionHeading.fromJson(Map<String, dynamic> json) =>
      _$PSectionHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionHeadingToJson(this);
}
