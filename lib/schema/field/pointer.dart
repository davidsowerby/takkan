import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/data/object/pointer.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class FPointer extends Field<PointerValidation, Pointer> {
  @override
  Type get modelType => Pointer;
  final String targetClass;

  FPointer({
    required this.targetClass,
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  factory FPointer.fromJson(Map<String, dynamic> json) =>
      _$FPointerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FPointerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PointerValidation implements ModelValidation<ValidatePointer, Pointer> {
  @override
  final ValidatePointer method;
  @override
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
