import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/common/exceptions.dart';

part 'pc.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class Precept {
  final List<PComponent> components;

  Precept({@required this.components});

  factory Precept.fromJson(Map<String, dynamic> json) =>
      _$PreceptFromJson(json);

  Map<String, dynamic> toJson() => _$PreceptToJson(this);
}

@JsonSerializable(nullable: false, explicitToJson: true)
@_PPartMapConverter()
class PComponent {
  final Map<String, PPart> parts;
  final String name;

  final List<PRoute> routes;

  PComponent({this.parts, @required this.routes, @required this.name});

  factory PComponent.fromJson(Map<String, dynamic> json) =>
      _$PComponentFromJson(json);

  Map<String, dynamic> toJson() => _$PComponentToJson(this);
}

abstract class PPart {
  final String caption;
  final String property;

  PPart({this.caption, @required this.property});

  Map<String, dynamic> toJson();
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

  final List<PSection> sections;

  PPage({this.title, @required this.sections});

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  Map<String, dynamic> toJson() => _$PPageToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
@_PPartConverter()
class PSection {
  final List<PPart> parts;

  factory PSection.fromJson(Map<String, dynamic> json) =>
      _$PSectionFromJson(json);

  Map<String, dynamic> toJson() => _$PSectionToJson(this);

  PSection({@required this.parts});
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PStringPart extends PPart {
  PStringPart({String caption, @required String property})
      : super(caption: caption, property: property);

  factory PStringPart.fromJson(Map<String, dynamic> json) =>
      pPartFromJson(json);

  Map<String, dynamic> toJson() => pPartToJson(this);

  static pPartFromJson(Map<String, dynamic> json) {
    return PStringPart(
      caption: json['caption'] as String,
      property: json['property'] as String,
    );
  }

  Map<String, dynamic> pPartToJson(PPart instance) => <String, dynamic>{
        'caption': instance.caption,
      };
}

class _PPartConverter implements JsonConverter<PPart, Map<String, dynamic>> {
  const _PPartConverter();

  @override
  PPart fromJson(Map<String, dynamic> json) {
    final partType = json["-part-"];
    switch (partType) {
      case "PStringPart":
        return PStringPart.fromJson(json);
      default:
        throw PreceptException("part type $partType not recognised");
    }
  }

  @override
  Map<String, dynamic> toJson(PPart object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = object.toJson();
    jsonMap["-part-"] = type.toString();
    return jsonMap;
  }
}

class _PPartMapConverter
    implements JsonConverter<Map<String, PPart>, Map<String, dynamic>> {
  const _PPartMapConverter();

  @override
  Map<String, PPart> fromJson(Map<String, dynamic> json) {
    Map<String, PPart> outputMap = Map();
    for (var entry in json.entries) {
      if (entry.key != "-part-") {
        outputMap[entry.key] = _PPartConverter().fromJson(entry.value);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, PPart> partMap) {
    final outputMap = Map<String, dynamic>();
    if (partMap == null) {
      return outputMap;
    }
    for (var entry in partMap.entries) {
      outputMap[entry.key] = _PPartConverter().toJson(entry.value);
    }
    return outputMap;
  }
}
