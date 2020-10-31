import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/modelDocument.dart';
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
  final PDocument document;

  PRoute({@required this.path, @required this.page, @required this.document});

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPage {
  final String title;

  final List<PSection> sections;

  PPage({@required this.title, @required this.sections});

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  Map<String, dynamic> toJson() => _$PPageToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
@PPartConverter()
class PSection {
  final List<PPart> parts;
  final PSectionHeading heading;
  final String property;

  factory PSection.fromJson(Map<String, dynamic> json) =>
      _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  PSection({
    @required this.parts,
    this.heading,
    @required this.property,
  });
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
