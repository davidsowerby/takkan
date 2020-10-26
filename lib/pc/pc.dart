import 'package:json_annotation/json_annotation.dart';

part 'pc.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class PComponent {
  final Map<String, PPart> parts;
  final List<PRoute> routes;

  PComponent({this.parts, this.routes});

  factory PComponent.fromJson(Map<String, dynamic> json) =>
      _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPart {
  final String title;

  factory PPart.fromJson(Map<String, dynamic> json) => _$PPartFromJson(json);

  Map<String, dynamic> toJson() => _$PPartToJson(this);

  PPart({this.title});
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute {
  final String path;

  final PPage page;

  PRoute({this.path, this.page});

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPage {
  final String title;

  final List<PSection> sections;

  PPage({this.title, this.sections});

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  Map<String, dynamic> toJson() => _$PPageToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PSection {
  final Wiggly wiggly;

  factory PSection.fromJson(Map<String, dynamic> json) =>
      _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  PSection({this.wiggly});
}

enum Wiggly { big, small }

class FieldLookup {}

class Blat {
  final String v1 = "blat1";
  final String v2 = "blat2";
}

class Blat2 extends Blat {
  final String v1 = "blat21";
}

Blat2 b = Blat2();
String s = b.v2;
