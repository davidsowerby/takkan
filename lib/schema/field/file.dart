import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/validation/validator.dart';

part 'file.g.dart';

@JsonSerializable(explicitToJson: true)
class PFile extends PField<FileValidation, String> {
  PFile({
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

  factory PFile.fromJson(Map<String, dynamic> json) => _$PFileFromJson(json);

  Map<String, dynamic> toJson() => _$PFileToJson(this);
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
