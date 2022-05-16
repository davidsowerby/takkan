import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/relation.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'relation.g.dart';

@JsonSerializable(explicitToJson: true)
class FRelation extends Field<RelationValidation, Relation> {
  @override
  Type get modelType => Relation;
  final String targetClass;

  FRelation({
    required this.targetClass,
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FRelation.fromJson(Map<String, dynamic> json) =>
      _$FRelationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FRelationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RelationValidation
    implements ModelValidation<ValidateRelation, Relation> {
  @override
  final ValidateRelation method;
  @override
  final Relation? param;

  const RelationValidation({required this.method, this.param});

  factory RelationValidation.fromJson(Map<String, dynamic> json) =>
      _$RelationValidationFromJson(json);

  Map<String, dynamic> toJson() => _$RelationValidationToJson(this);
}

// TODO: Not sure that validation is ever actually appropriate?
enum ValidateRelation {
  isValid,
}

validateRelation(RelationValidation validation, Relation value) {
  switch (validation.method) {
    case ValidateRelation.isValid:
      return true;
  }
}
