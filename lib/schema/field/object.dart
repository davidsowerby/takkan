import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/json_object.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'object.g.dart';

/// An embedded JSON object
@JsonSerializable(explicitToJson: true)
class FObject extends Field<ObjectValidation, Map<String, dynamic>> {
  Type get modelType => JsonObject;

  FObject({
    Map<String, dynamic>? defaultValue,
    List<ObjectValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          required: required,
          readOnly: readOnly,
        );

  factory FObject.fromJson(Map<String, dynamic> json) =>
      _$FObjectFromJson(json);

  Map<String, dynamic> toJson() => _$FObjectToJson(this);
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
