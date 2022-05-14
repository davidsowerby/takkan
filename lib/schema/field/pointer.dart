import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/object/pointer.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class FPointer extends Field<PointerValidation, Pointer> {
  Type get modelType => Pointer;
  final String targetClass;

  FPointer({
    Pointer? defaultValue,
    required this.targetClass,
    List<PointerValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          readOnly: readOnly,
          defaultValue: defaultValue,
          required: required,
          validations: validations,
        );

  factory FPointer.fromJson(Map<String, dynamic> json) =>
      _$FPointerFromJson(json);

  Map<String, dynamic> toJson() => _$FPointerToJson(this);
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
