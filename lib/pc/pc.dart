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

  static pPartFromJson(Map<String, dynamic> json) {
    return PPart(
      caption: json['caption'] as String,
    );
  }

  Map<String, dynamic> pPartToJson(PPart instance) {
    return <String, dynamic>{
      'caption': instance.caption,
    };
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPart {
  final String caption;

  // @JsonKey(fromJson: paramsFromJson, toJson: paramsToJson)
  //
  // final PartParams params;

  factory PPart.fromJson(Map<String, dynamic> json) => pPartFromJson(json);

  Map<String, dynamic> toJson() => pPartToJson(this);

  PPart({this.caption});

  static pPartFromJson(Map<String, dynamic> json) {
    return PPart(
      caption: json['caption'] as String,
    );
  }

  Map<String, dynamic> pPartToJson(PPart instance) =>
      <String, dynamic>{
        'caption': instance.caption,
      };
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PRoute {
  final String path;

  final PPage page;

  PRoute({this.path, this.page});

  factory PRoute.fromJson(Map<String, dynamic> json) => _$PRouteFromJson(json);

  Map<String, dynamic> toJson() => _$PRouteToJson(this);
}

// @JsonSerializable()
// class GenericClass<T extends num, S> {
//   @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
//   Object fieldObject;
//
//   @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
//   dynamic fieldDynamic;
//
//   @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
//   int fieldInt;
//
//   @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
//   T fieldT;
//
//   @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
//   S fieldS;
//
//   GenericClass();
//
//   factory GenericClass.fromJson(Map<String, dynamic> json) =>
//       _$GenericClassFromJson<T, S>(json);
//
//   Map<String, dynamic> toJson() => _$GenericClassToJson(this);
//
//   static T _dataFromJson<T, S, U>(Map<String, dynamic> input,
//       [S other1, U other2]) =>
//       input['value'] as T;
//
//   static Map<String, dynamic> _dataToJson<T, S, U>(T input,
//       [S other1, U other2]) =>
//       {'value': input};
// }

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

@JsonSerializable(nullable: true, explicitToJson: true)
class PStringPart extends PPart {
  PStringPart({String caption}) : super(caption: caption);

  factory PStringPart.fromJson(Map<String, dynamic> json) =>
      pPartFromJson(json);

  Map<String, dynamic> toJson() => pPartToJson(this);

  static pPartFromJson(Map<String, dynamic> json) {
    return PStringPart(
      caption: json['caption'] as String,
    );
  }

  Map<String, dynamic> pPartToJson(PPart instance) =>
      <String, dynamic>{
        'caption': instance.caption,
      };
}
