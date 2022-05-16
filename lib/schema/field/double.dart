import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'double.g.dart';

@JsonSerializable(explicitToJson: true)
class FDouble extends Field<DoubleValidation, double> {
  @override
  Type get modelType => double;

  FDouble({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  });

  factory FDouble.fromJson(Map<String, dynamic> json) =>
      _$FDoubleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FDoubleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DoubleValidation implements ModelValidation<ValidateDouble, double> {
  @override
  final ValidateDouble method;
  @override
  final double param;

  const DoubleValidation({required this.method, required this.param});

  factory DoubleValidation.fromJson(Map<String, dynamic> json) =>
      _$DoubleValidationFromJson(json);

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
