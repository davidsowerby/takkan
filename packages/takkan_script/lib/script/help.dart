import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'help.g.dart';

@JsonSerializable(explicitToJson: true)
class Help extends Equatable {
  const Help({required this.title, this.message});

  factory Help.fromJson(Map<String, dynamic> json) => _$HelpFromJson(json);
  final String title;
  final String? message;

  Map<String, dynamic> toJson() => _$HelpToJson(this);

  @override
  List<Object?> get props => [title, message];
}
