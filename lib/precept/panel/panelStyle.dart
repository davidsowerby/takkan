import 'package:json_annotation/json_annotation.dart';

part 'panelStyle.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PanelStyle  {

  PanelStyle() ;

  factory PanelStyle.fromJson(Map<String, dynamic> json) =>
      _$PanelStyleFromJson(json);

  Map<String, dynamic> toJson() => _$PanelStyleToJson(this);
}