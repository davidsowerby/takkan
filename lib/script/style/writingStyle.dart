import 'package:json_annotation/json_annotation.dart';

part 'writingStyle.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class WritingStyle  {

  WritingStyle() ;

  factory WritingStyle.fromJson(Map<String, dynamic> json) =>
      _$WritingStyleFromJson(json);

  Map<String, dynamic> toJson() => _$WritingStyleToJson(this);
}