import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/object/jsonObject.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'object.g.dart';

/// An embedded JSON object
@JsonSerializable(explicitToJson: true)
class PJsonObject extends PField<ObjectValidation, Map<String, dynamic>> {
  Type get modelType => JsonObject;

  PJsonObject({
    Map<String, dynamic>? defaultValue,
    List<ObjectValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          permissions: permissions,
          required: required,
        );

  factory PJsonObject.fromJson(Map<String, dynamic> json) =>
      _$PJsonObjectFromJson(json);

  Map<String, dynamic> toJson() => _$PJsonObjectToJson(this);

  @override
  bool doValidation(ObjectValidation validation, Map<String, dynamic> value) {
    return validateObject(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class ObjectValidation
    implements ModelValidation<ValidateObject, Map<String, dynamic>> {
  final ValidateObject method;
  final dynamic param;

  const ObjectValidation({required this.method, required this.param});

  factory ObjectValidation.fromJson(Map<String, dynamic> json) =>
      _$ObjectValidationFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectValidationToJson(this);
}

enum ValidateObject { isNotEmpty }

validateObject(ObjectValidation validation, Map<String, dynamic> value) {
  switch (validation.method) {
    case ValidateObject.isNotEmpty:
      return value.isNotEmpty;
  }
}
