import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/object/pointer.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class PPointer extends PField<PointerValidation, Pointer> {
  Type get modelType => Pointer;
  final String targetClass;

  PPointer({
    Pointer? defaultValue,
    required this.targetClass,
    List<PointerValidation> validations = const [],
    PPermissions? permissions,
    bool required = false,
  }) : super(
          defaultValue: defaultValue,
          required: required,
          validations: validations,
          permissions: permissions,
        );

  factory PPointer.fromJson(Map<String, dynamic> json) =>
      _$PPointerFromJson(json);

  Map<String, dynamic> toJson() => _$PPointerToJson(this);

  @override
  bool doValidation(PointerValidation validation, Pointer value) {
    return validatePointer(validation, value);
  }
}

@JsonSerializable(explicitToJson: true)
class PointerValidation implements ModelValidation<ValidatePointer, Pointer> {
  final ValidatePointer method;
  final Pointer? param;

  const PointerValidation({required this.method, this.param});

  factory PointerValidation.fromJson(Map<String, dynamic> json) =>
      _$PointerValidationFromJson(json);

  Map<String, dynamic> toJson() => _$PointerValidationToJson(this);
}

enum ValidatePointer {
  isValid,
}

validatePointer(PointerValidation validation, Pointer value) {
  switch (validation.method) {
    case ValidatePointer.isValid:
      return true;
  }
}
