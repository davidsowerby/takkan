import 'package:json_annotation/json_annotation.dart';

import '../../data/object/relation.dart';
import '../../script/common.dart';
import 'field.dart';

part 'relation.g.dart';

@JsonSerializable(explicitToJson: true)
class FRelation extends Field< Relation> {

  FRelation({
    required this.targetClass,
    super.defaultValue,
    super. constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FRelation.fromJson(Map<String, dynamic> json) =>
      _$FRelationFromJson(json);
  @override
  Type get modelType => Relation;
  final String targetClass;

  @override
  Map<String, dynamic> toJson() => _$FRelationToJson(this);
}
