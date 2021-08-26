import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'date.g.dart';

@JsonSerializable(explicitToJson: true)
class PDate extends PField<DateValidation, DateTime> {
  Type get modelType => DateTime;

  PDate({
    DateTime? defaultValue,
    List<DateValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
    defaultValue: defaultValue,
          validations: validations,
          permissions: permissions,
          required: required,
        );

  factory PDate.fromJson(Map<String, dynamic> json) => _$PDateFromJson(json);

  Map<String, dynamic> toJson() => _$PDateToJson(this);

  @override
  bool doValidation(DateValidation validation, DateTime value) {
    return validateDate(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class DateValidation implements ModelValidation<ValidateDate, DateTime> {
  final ValidateDate method;
  final DateTime param;

  const DateValidation({required this.method, required this.param});

  factory DateValidation.fromJson(Map<String, dynamic> json) =>
      _$DateValidationFromJson(json);

  Map<String, dynamic> toJson() => _$DateValidationToJson(this);
}

enum ValidateDate { isLaterThan, isBefore }

validateDate(DateValidation validation, DateTime value) {
  switch (validation.method) {
    case ValidateDate.isLaterThan:
      return isGreaterThan(value, validation.param);
    case ValidateDate.isBefore:
      return isLessThan(value, validation.param);
  }
}

bool isGreaterThan(DateTime value, DateTime limit) {
  return value.isAfter(limit);
}

bool isLessThan(DateTime value, DateTime limit) {
  return value.isBefore(limit);
}
