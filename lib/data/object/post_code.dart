import 'package:json_annotation/json_annotation.dart';

part 'post_code.g.dart';

@JsonSerializable( explicitToJson: true)
class PostCode  {

  const PostCode({required this.postCode}) ;

  factory PostCode.fromJson(Map<String, dynamic> json) =>
      _$PostCodeFromJson(json);
 final String postCode;

  Map<String, dynamic> toJson() => _$PostCodeToJson(this);
}
