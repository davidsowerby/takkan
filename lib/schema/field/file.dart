import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'file.g.dart';

@JsonSerializable(explicitToJson: true)
class FFile extends Field<FileValidation, String> {
  FFile({
    String? defaultValue,
    List<FileValidation> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
          defaultValue: defaultValue,
          validations: validations,
          required: required,
          readOnly: readOnly,
        );

  Type get modelType => File;

  factory FFile.fromJson(Map<String, dynamic> json) => _$FFileFromJson(json);

  Map<String, dynamic> toJson() => _$FFileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FileValidation implements ModelValidation<ValidateFile, String> {
  final ValidateFile method;
  final bool? param;

  const FileValidation({required this.method, this.param});

  factory FileValidation.fromJson(Map<String, dynamic> json) =>
      _$FileValidationFromJson(json);

  Map<String, dynamic> toJson() => _$FileValidationToJson(this);
}

enum ValidateFile { exists }

validateFile(FileValidation validation, String value) {
  switch (validation.method) {
    case ValidateFile.exists:
      return File(value).exists();
  }
}
