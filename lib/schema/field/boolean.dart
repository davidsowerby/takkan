import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'boolean.g.dart';

@JsonSerializable(explicitToJson: true)
class FBoolean extends Field<BooleanValidation, bool> {
  FBoolean({
    bool? defaultValue,
    List<BooleanValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          required: required,
          readOnly: readOnly,
        );

  Type get modelType => bool;

  factory FBoolean.fromJson(Map<String, dynamic> json) =>
      _$FBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$FBooleanToJson(this);
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
