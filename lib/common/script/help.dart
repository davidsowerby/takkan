import 'package:json_annotation/json_annotation.dart';

part 'help.g.dart';

@JsonSerializable( explicitToJson: true)
class PHelp {
  final String title;
  final String? message;

  const PHelp({required this.title, this.message});

  factory PHelp.fromJson(Map<String, dynamic> json) =>
      _$PHelpFromJson(json);

  Map<String, dynamic> toJson() => _$PHelpToJson(this);
}