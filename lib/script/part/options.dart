import 'package:json_annotation/json_annotation.dart';

part 'options.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PReadModeOptions {
  final String styleName;
  final bool showCaption;

  const PReadModeOptions({this.styleName = "default", this.showCaption = true});

  factory PReadModeOptions.fromJson(Map<String, dynamic> json) =>
      _$PReadModeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PReadModeOptionsToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PEditModeOptions {
  final String styleName;
  final bool showCaption;

  const PEditModeOptions({this.styleName = "default", this.showCaption = true});

  factory PEditModeOptions.fromJson(Map<String, dynamic> json) =>
      _$PEditModeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PEditModeOptionsToJson(this);


}
