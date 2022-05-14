import 'package:json_annotation/json_annotation.dart';

part 'panel_style.g.dart';

@JsonSerializable(explicitToJson: true)
class PanelStyle {
  final bool expandable;
  final bool openExpanded;

  const PanelStyle({
    this.expandable = true,
    this.openExpanded = true,
  });

  factory PanelStyle.fromJson(Map<String, dynamic> json) =>
      _$PanelStyleFromJson(json);

  Map<String, dynamic> toJson() => _$PanelStyleToJson(this);
}