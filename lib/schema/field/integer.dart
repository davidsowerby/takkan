import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
class PInteger extends PField<IntegerValidation, int> {
  final int? defaultValue;

  Type get modelType => int;

  PInteger({
    this.defaultValue,
    List<IntegerValidation> validations = const [],
    PPermissions? permissions,
  }) : super(
          validations: validations,
          permissions: permissions,
        );

  factory PInteger.fromJson(Map<String, dynamic> json) =>
      _$PIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$PIntegerToJson(this);

  @override
  bool doValidation(IntegerValidation validation, int value) {
    return validateInteger(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class IntegerValidation implements ModelValidation<ValidateInteger, int> {
  final ValidateInteger method;
  final int param;

  const IntegerValidation({required this.method, this.param = 0});

  factory IntegerValidation.fromJson(Map<String, dynamic> json) =>
      _$IntegerValidationFromJson(json);

  Map<String, dynamic> toJson() => _$IntegerValidationToJson(this);
}

enum ValidateInteger { isGreaterThan, isLessThan }

bool validateInteger(IntegerValidation validation, int value) {
  switch (validation.method) {
    case ValidateInteger.isGreaterThan:
      return isGreaterThan(value, validation.param);
    case ValidateInteger.isLessThan:
      return isLessThan(value, validation.param);
  }
}

bool isGreaterThan(int value, int limit) {
  return value > limit;
}

bool isLessThan(int value, int limit) {
  return value < limit;
}
