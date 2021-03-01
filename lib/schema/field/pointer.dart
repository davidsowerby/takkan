import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/pointer.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'pointer.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PPointer extends PField<PointerValidation, Pointer> {
  final Pointer defaultValue;

  Type get modelType => Pointer;

  PPointer({this.defaultValue, List<PointerValidation> validations, PPermissions permissions,}) : super(validations: validations,permissions: permissions,);

  factory PPointer.fromJson(Map<String, dynamic> json) => _$PPointerFromJson(json);

  Map<String, dynamic> toJson() => _$PPointerToJson(this);

  @override
  bool doValidation(PointerValidation validation, Pointer value) {
    return validatePointer(validation, value);
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PointerValidation implements ModelValidation<ValidatePointer, Pointer> {
  final ValidatePointer method;
  final Pointer param;

  const PointerValidation({@required this.method, this.param});

  factory PointerValidation.fromJson(Map<String, dynamic> json) =>
      _$PointerValidationFromJson(json);

  Map<String, dynamic> toJson() => _$PointerValidationToJson(this);
}

// TODO: Not sure that validation is ever actually appropriate?
enum ValidatePointer {
  isValid,
}

validatePointer(PointerValidation validation, Pointer value) {
  switch (validation.method) {
    case ValidatePointer.isValid:
      return true;
  }
}
