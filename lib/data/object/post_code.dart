import 'package:json_annotation/json_annotation.dart';

part 'post_code.g.dart';

@JsonSerializable( explicitToJson: true)
class PostCode  {
 final String postCode;

  const PostCode({required this.postCode}) ;

  factory PostCode.fromJson(Map<String, dynamic> json) =>
      _$PostCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PostCodeToJson(this);
}