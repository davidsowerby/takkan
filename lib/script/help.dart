import 'package:json_annotation/json_annotation.dart';

part 'help.g.dart';

@JsonSerializable(explicitToJson: true)
class Help {
  final String title;
  final String? message;

  const Help({required this.title, this.message});

  factory Help.fromJson(Map<String, dynamic> json) => _$HelpFromJson(json);

  Map<String, dynamic> toJson() => _$HelpToJson(this);
}