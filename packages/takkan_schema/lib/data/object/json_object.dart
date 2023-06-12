import 'package:json_annotation/json_annotation.dart';

part 'json_object.g.dart';

@JsonSerializable(explicitToJson: true)
class JsonObject {
  JsonObject();

  factory JsonObject.fromJson(Map<String, dynamic> json) =>
      _$JsonObjectFromJson(json);

  Map<String, dynamic> toJson() => _$JsonObjectToJson(this);
}
