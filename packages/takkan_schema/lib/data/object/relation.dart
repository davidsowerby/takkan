import 'package:json_annotation/json_annotation.dart';

part 'relation.g.dart';

@JsonSerializable(explicitToJson: true)
class Relation {
  Relation();

  factory Relation.fromJson(Map<String, dynamic> json) =>
      _$RelationFromJson(json);

  Map<String, dynamic> toJson() => _$RelationToJson(this);
}
