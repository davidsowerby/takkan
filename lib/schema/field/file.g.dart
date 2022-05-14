// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FFile _$FFileFromJson(Map<String, dynamic> json) => FFile(
      defaultValue: json['defaultValue'] as String?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => FileValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FFileToJson(FFile instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue);
  return val;
}

FileValidation _$FileValidationFromJson(Map<String, dynamic> json) =>
    FileValidation(
      method: $enumDecode(_$ValidateFileEnumMap, json['method']),
      param: json['param'] as bool?,
    );

Map<String, dynamic> _$FileValidationToJson(FileValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateFileEnumMap[instance.method],
      'param': instance.param,
    };

const _$ValidateFileEnumMap = {
  ValidateFile.exists: 'exists',
};
