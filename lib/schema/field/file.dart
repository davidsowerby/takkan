import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/validation/validator.dart';

part 'file.g.dart';

@JsonSerializable(explicitToJson: true)
class FFile extends Field<FileValidation, String> {
  FFile({
    super. defaultValue,
    super.validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  }) ;

  @override
  Type get modelType => File;

  factory FFile.fromJson(Map<String, dynamic> json) => _$FFileFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FFileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FileValidation implements ModelValidation<ValidateFile, String> {
  @override
  final ValidateFile method;
  @override
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
