import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/validation/validator.dart';
import 'package:validators/validators.dart';

part 'string.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PString extends PField<StringValidation, String> {
  PString({
    String? defaultValue,
    List<StringValidation> validations = const [],
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  Type get modelType => String;

  factory PString.fromJson(Map<String, dynamic> json) =>
      _$PStringFromJson(json);

  Map<String, dynamic> toJson() => _$PStringToJson(this);

  @override
  bool doValidation(StringValidation validation, String value) {
    return validateString(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class PListString extends PList {
  PListString({
    List<String> defaultValue = const [],
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          required: required,
        );

  factory PListString.fromJson(Map<String, dynamic> json) =>
      _$PListStringFromJson(json);

  Map<String, dynamic> toJson() => _$PListStringToJson(this);

  @override
  Type get modelType => String;

  @override
  bool doValidation(ModelValidation validation, value) {
    // TODO: implement doValidation
    throw UnimplementedError();
  }
}

@JsonSerializable(explicitToJson: true)
class StringValidation implements ModelValidation<ValidateString, String> {
  final ValidateString method;
  final dynamic param;

  const StringValidation({required this.method, this.param});

  factory StringValidation.fromJson(Map<String, dynamic> json) =>
      _$StringValidationFromJson(json);

  Map<String, dynamic> toJson() => _$StringValidationToJson(this);
}

enum ValidateString {
  alpha,
  contains,
  lengthEquals,
  lengthGreaterThan,
  lengthLessThan
}

bool validateString(StringValidation validation, String value) {
  switch (validation.method) {
    case ValidateString.alpha:
      return isAlpha(value);
    case ValidateString.contains:
      return contains(value, validation.param);
    case ValidateString.lengthEquals:
      return value.length == validation.param;

    case ValidateString.lengthGreaterThan:
      return value.length > validation.param;
    case ValidateString.lengthLessThan:
      return value.length < validation.param;
  }
}
