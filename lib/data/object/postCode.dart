import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postCode.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PostCode  {
 final String postCode;

  const PostCode({@required this.postCode}) ;

  factory PostCode.fromJson(Map<String, dynamic> json) =>
      _$PostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PostCodeToJson(this);
}