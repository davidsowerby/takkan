import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'date.g.dart';

@JsonSerializable(explicitToJson: true)
class FDate extends Field<DateValidation, DateTime> {
  Type get modelType => DateTime;

  FDate({
    DateTime? defaultValue,
    List<DateValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          required: required,
          readOnly: readOnly,
        );

  factory FDate.fromJson(Map<String, dynamic> json) => _$FDateFromJson(json);

  Map<String, dynamic> toJson() => _$FDateToJson(this);
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
