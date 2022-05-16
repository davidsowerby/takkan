import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/json_object.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'object.g.dart';

/// An embedded JSON object
@JsonSerializable(explicitToJson: true)
class FObject extends Field<ObjectValidation, Map<String, dynamic>> {
  @override
  Type get modelType => JsonObject;

  FObject({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FObject.fromJson(Map<String, dynamic> json) =>
      _$FObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ObjectValidation
    implements ModelValidation<ValidateObject, Map<String, dynamic>> {
  @override
  final ValidateObject method;
  @override
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
