import 'package:json_annotation/json_annotation.dart';

part 'pointer.g.dart';

@JsonSerializable( explicitToJson: true)
class Pointer  {

  Pointer() ;

  factory Pointer.fromJson(Map<String, dynamic> json) =>
      _$PointerFromJson(json);

  Map<String, dynamic> toJson() => _$PointerToJson(this);
}
