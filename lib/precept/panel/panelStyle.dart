import 'package:json_annotation/json_annotation.dart';

part 'panelStyle.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanelStyle  {

  final bool expandable;
  final bool openExpanded;

  const PPanelStyle({this.expandable=true, this.openExpanded=true, }) ;

  factory PPanelStyle.fromJson(Map<String, dynamic> json) =>
      _$PPanelStyleFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelStyleToJson(this);
}