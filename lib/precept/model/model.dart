import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/partConverter.dart';
import 'package:precept/precept/part/string/stringPart.dart';

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

  final List<PDocumentSection> sections;

  PPage(
      {@required this.title,
      @required this.sections,
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
class PSection {
  final List<PSection> sections;
  @JsonKey(fromJson: PPartListConverter.fromJson, toJson: PPartListConverter.toJson)
  final List<PPart> parts;


  final PSectionHeading heading;
  final String property;
  final bool partsFirst;

  factory PSection.fromJson(Map<String, dynamic> json) =>
      _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  const PSection({
    this.parts=const[],
    this.sections = const [],
    this.heading,
    this.property,
    this.partsFirst = true,
  });
}

@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocumentSection extends PSection {
  final PDocumentSelector documentSelector;

  const PDocumentSection(
      {@required this.documentSelector,
        @JsonKey(fromJson: PPartListConverter.fromJson, toJson: PPartListConverter.toJson)
      List<PPart> parts=const[],
      List<PSection> sections=const[],
      PSectionHeading heading,
      String property="not required",
      bool partsFirst=true})
      : super(
            parts: parts,
            sections: sections,
            heading: heading,
            property: property,
            partsFirst: partsFirst);

  factory PDocumentSection.fromJson(Map<String, dynamic> json) =>
      _$PDocumentSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentSectionToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PSectionHeading {
  final String title;
  final bool expandable;
  final bool openExpanded;

  PSectionHeading({
    @required this.title,
    this.expandable = true,
    this.openExpanded = true,
  }) : super();

  factory PSectionHeading.fromJson(Map<String, dynamic> json) =>
      _$PSectionHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionHeadingToJson(this);
}
