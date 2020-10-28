import 'package:json_annotation/json_annotation.dart';

part 'options.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PReadModeOptions {
  final String styleName;
  final bool showCaption;

  const PReadModeOptions({this.styleName = "default", this.showCaption = true});

  factory PReadModeOptions.fromJson(Map<String, dynamic> json) =>
      pPartFromJson(json);

  Map<String, dynamic> toJson() => pPartToJson(this);

  static pPartFromJson(Map<String, dynamic> json) {
    return PReadModeOptions(
      styleName: json['styleName'] as String,
      showCaption: json['showCaption'] as bool,
    );
  }

  Map<String, dynamic> pPartToJson(PReadModeOptions instance) =>
      <String, dynamic>{
        'styleName': instance.styleName,
        'showCaption': instance.showCaption,
      };
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PEditModeOptions {
  final String styleName;
  final bool showCaption;

  const PEditModeOptions({this.styleName = "default", this.showCaption = true});

  factory PEditModeOptions.fromJson(Map<String, dynamic> json) =>
      pPartFromJson(json);

  Map<String, dynamic> toJson() => pPartToJson(this);

  static pPartFromJson(Map<String, dynamic> json) {
    return PEditModeOptions(
      styleName: json['styleName'] as String,
      showCaption: json['showCaption'] as bool,
    );
  }

  Map<String, dynamic> pPartToJson(PEditModeOptions instance) =>
      <String, dynamic>{
        'styleName': instance.styleName,
        'showCaption': instance.showCaption,
      };
}
