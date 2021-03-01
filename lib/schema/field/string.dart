import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/select.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'string.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PField<StringValidation, String> {
  final String defaultValue;

  PString({
    this.defaultValue,
    List<StringValidation> validations,
    Permissions permissions,
  }) : super(
          validations: validations,
          permissions: permissions,
        );

  Type get modelType => String;

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  Map<String, dynamic> toJson() => _$PStringToJson(this);

  @override
  bool doValidation(StringValidation validation, String value) {
    return validateString(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListString extends PListField {
  final List<String> defaultValue;

  PListString({this.defaultValue = const []});

  factory PListString.fromJson(Map<String, dynamic> json) => _$PListStringFromJson(json);

  Map<String, dynamic> toJson() => _$PListStringToJson(this);

  @override
  Type get modelType => String;

  @override
  bool doValidation(ModelValidation validation, value) {
    // TODO: implement doValidation
    throw UnimplementedError();
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class StringValidation implements ModelValidation<ValidateString, String> {
  final ValidateString method;
  final dynamic param;

  const StringValidation({@required this.method, this.param});

  factory StringValidation.fromJson(Map<String, dynamic> json) => _$StringValidationFromJson(json);

  Map<String, dynamic> toJson() => _$StringValidationToJson(this);
}

enum ValidateString { isLongerThan, isShorterThan }

bool validateString(StringValidation validation, String value) {
  switch (validation.method) {
    case ValidateString.isLongerThan:
      return isLongerThan(value, validation.param as int);
    case ValidateString.isShorterThan:
      return isShorterThan(value, validation.param as int);
    default:
      throw UnimplementedError();
  }
}

bool isLongerThan(String value, int limit) {
  return value.length > limit;
}

bool isShorterThan(String value, int limit) {
  return value.length < limit;
}
