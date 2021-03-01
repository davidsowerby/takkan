import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'boolean.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PBoolean extends PField<BooleanValidation, bool> {
  final bool defaultValue;

  PBoolean({
    this.defaultValue,
    List<BooleanValidation> validations,
    PPermissions permissions,
  }) : super(
          validations: validations,
          permissions: permissions,
        );

  Type get modelType => bool;

  factory PBoolean.fromJson(Map<String, dynamic> json) => _$PBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PBooleanToJson(this);

  @override
  bool doValidation(BooleanValidation validation, bool value) {
    return validateBoolean(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class BooleanValidation implements ModelValidation<ValidateBoolean, bool> {
  final ValidateBoolean method;
  final bool param;

  const BooleanValidation({@required this.method, this.param});

  factory BooleanValidation.fromJson(Map<String, dynamic> json) =>
      _$BooleanValidationFromJson(json);

  Map<String, dynamic> toJson() => _$BooleanValidationToJson(this);
}

enum ValidateBoolean { isTrue, isFalse }

validateBoolean(BooleanValidation validation, bool value) {
  switch (validation.method) {
    case ValidateBoolean.isTrue:
      return value == true;
    case ValidateBoolean.isFalse:
      return value == false;
  }
}
