import 'package:json_annotation/json_annotation.dart';

part 'postCode.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PostCode  {

  PostCode() ;

  factory PostCode.fromJson(Map<String, dynamic> json) =>
      _$PostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PostCodeToJson(this);
}