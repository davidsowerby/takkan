import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'double.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PDouble extends PField<DoubleValidation, double> {
  final double defaultValue;

  Type get modelType => double;

  PDouble({this.defaultValue, List<DoubleValidation> validations})
      : super(validations: validations);

  factory PDouble.fromJson(Map<String, dynamic> json) => _$PDoubleFromJson(json);

  Map<String, dynamic> toJson() => _$PDoubleToJson(this);

  @override
  bool doValidation(DoubleValidation validation, double value) {
    return validateDouble(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class DoubleValidation implements ModelValidation<ValidateDouble, double> {
  final ValidateDouble method;
  final double param;

  const DoubleValidation({@required this.method, this.param});

  factory DoubleValidation.fromJson(Map<String, dynamic> json) => _$DoubleValidationFromJson(json);

  Map<String, dynamic> toJson() => _$DoubleValidationToJson(this);
}

enum ValidateDouble { isGreaterThan, isLessThan }

validateDouble(DoubleValidation validation, double value) {
  switch (validation.method) {
    case ValidateDouble.isGreaterThan:
      return isGreaterThan(value, validation.param);
    case ValidateDouble.isLessThan:
      return isLessThan(value, validation.param);
  }
}

bool isGreaterThan(double value, double limit) {
  return value > limit;
}

bool isLessThan(double value, double limit) {
  return value < limit;
}
