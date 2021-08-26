import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'boolean.g.dart';

@JsonSerializable(explicitToJson: true)
class PBoolean extends PField<BooleanValidation, bool> {
  PBoolean({
    bool? defaultValue,
    List<BooleanValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          permissions: permissions,
          required: required,
        );

  Type get modelType => bool;

  factory PBoolean.fromJson(Map<String, dynamic> json) =>
      _$PBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$PBooleanToJson(this);

  @override
  bool doValidation(BooleanValidation validation, bool value) {
    return validateBoolean(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class BooleanValidation implements ModelValidation<ValidateBoolean, bool> {
  final ValidateBoolean method;
  final bool? param;

  const BooleanValidation({required this.method, this.param});

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
