import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/relation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'relation.g.dart';

@JsonSerializable(explicitToJson: true)
class PRelation extends PField<RelationValidation, Relation> {
  Type get modelType => Relation;
  final String targetClass;

  PRelation({
    Relation? defaultValue,
    required this.targetClass,
    List<RelationValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
    readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory PRelation.fromJson(Map<String, dynamic> json) =>
      _$PRelationFromJson(json);

  Map<String, dynamic> toJson() => _$PRelationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RelationValidation
    implements ModelValidation<ValidateRelation, Relation> {
  final ValidateRelation method;
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
